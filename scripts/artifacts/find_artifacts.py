import os
import sys
import json
from datetime import datetime, timezone
from collections import defaultdict

import requests
from cirrus_run import CirrusAPI as GraphqlAPI

class GitLabAPI(GraphqlAPI):
    USER_AGENT = 'One-off script to find artifacts taking up storage space'
    DEFAULT_URL = 'https://gitlab.com/api/graphql'

query = '''
  query GetPipelineArtifacts($repo: ID!, $page: String)
    {
      project(fullPath: $repo) {
        id
        pipelines(after: $page) {
          pageInfo {
            endCursor
            hasNextPage
            hasPreviousPage
          }
          nodes {
            complete
            finishedAt
            id
            jobArtifacts {
              name
              fileType
              downloadPath
              size
            }
          }
        }
      }
    }
'''.strip()

def stderr(message):
    print(message, file=sys.stderr)

def main():
    token = os.getenv('GRAPHQL_API_TOKEN')
    api = GitLabAPI(token)
    if token:
        def delete(url):
            return requests.delete(url, headers={'private-token': token})
    repo = sys.argv[1]
    page = None
    cursor = ''
    size = defaultdict(int)
    now = datetime.now(tz=timezone.utc)

    while page is None or page['project']['pipelines']['pageInfo']['hasNextPage']:
        if page is not None:
            cursor = page['project']['pipelines']['pageInfo']['endCursor']
        page = api(query, params=dict(repo=repo, page=cursor))
        project_id = page['project']['id'].split('/')[-1]
        for pipeline in page['project']['pipelines']['nodes']:
            if not pipeline['complete']:
                continue
            timestamp = datetime.fromisoformat(pipeline['finishedAt'].replace('Z', '+00:00'))
            pipeline_id = pipeline['id'].split('/')[-1]
            for artifact in pipeline['jobArtifacts']:
                size[artifact['name']] += artifact['size']
                if artifact['size'] >= 10 * 2**20:
                    stderr('Large artifact: %s' % artifact['downloadPath'])
            if (now - timestamp).days > 365 and 'delete' in locals():
                rest_url = f'https://gitlab.com/api/v4/projects/{project_id}/pipelines/{pipeline_id}'
                http = delete(rest_url)
                if 200 <= http.status_code < 300:
                    stderr(f'Deleted pipeline {pipeline["id"]}')
                else:
                    stderr(f'HTTP {http.status_code} while deleting {pipeline["id"]}: {rest_url}')
        print(json.dumps(page, indent=2, ensure_ascii=False, sort_keys=True))
    for filename, filesize in size.items():
        stderr(f'{filename:>19}: {filesize / 2**20:.1f}MB ({filesize} bytes)')
    total_size = sum(size.values())
    stderr(f'TOTAL ARTIFACT SIZE: {total_size / 2**20:.1f}MB ({total_size} bytes)')

if __name__ == '__main__':
    main()
