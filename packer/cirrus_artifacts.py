'''
List direct URLs for latest artifacts of Cirrus CI build
'''


import os
import json

from cirrus_run import CirrusAPI
from cirrus_run.cli import parse_args
from cirrus_run.queries import get_repo


ENVIRONMENT = {
    'build': 'CIRRUS_ARTIFACTS_BUILD',
}


def main(*a, **ka):
    args = parse_args(*a, **ka)
    api = CirrusAPI(args.token)
    repo_id = get_repo(api, args.owner, args.repo)

    build_id = os.getenv(ENVIRONMENT['build'])
    if not build_id:
        raise ValueError('environment variable not set: {}'.format(ENVIRONMENT['build']))

    for url in artifact_urls(api, build_id):
        print(url)


def artifact_urls(api, build_id):
    query = '''
        query artifacts($build_id: ID!) {
            build(id: $build_id) {
                tasks {
                    id
                    artifacts {
                        name
                        files {
                            path
                        }
                    }
                }
            }
        }
    '''
    params = dict(build_id=build_id)
    response = api(query, params)
    url_template = 'https://api.cirrus-ci.com/v1/artifact/task/{task[id]}/{artifact[name]}/{file_[path]}'
    for task in response['build']['tasks']:
        for artifact in task['artifacts']:
            for file_ in artifact['files']:
                yield url_template.format(**locals())


if __name__ == '__main__':
    main()
