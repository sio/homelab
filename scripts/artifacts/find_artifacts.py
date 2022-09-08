import os
import sys
import json

from cirrus_run import CirrusAPI as GraphqlAPI

class GitLabAPI(GraphqlAPI):
    USER_AGENT = 'One-off script to find artifacts taking up storage space'
    DEFAULT_URL = 'https://gitlab.com/api/graphql'

query = '''
  query GetPipelineArtifacts($repo: ID!, $page: String)
    {
      project(fullPath: $repo) {
        pipelines(after: $page) {
          pageInfo {
            endCursor
            hasNextPage
            hasPreviousPage
          }
          nodes {
            jobArtifacts {
              name
              fileType
              downloadPath
            }
          }
        }
      }
    }
'''.strip()

def main():
    api = GitLabAPI(os.getenv('GRAPHQL_API_TOKEN'))
    repo = sys.argv[1]
    page = None
    cursor = ''
    while page is None or page['project']['pipelines']['pageInfo']['hasNextPage']:
        if page is not None:
            cursor = page['project']['pipelines']['pageInfo']['endCursor']
        page = api(query, params=dict(repo=repo, page=cursor))
        print(json.dumps(page, indent=2, ensure_ascii=False, sort_keys=True))

if __name__ == '__main__':
    main()
