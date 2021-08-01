#!/usr/bin/env python3
'''
Show status of previous CI pipeline

Wait for the previous pipeline to finish if it's still running
'''


import json
import os
import urllib.request


def check_environment():
    required = ['CI_PROJECT_ID', 'CHECK_BRANCH', 'CHECK_PIPELINE']
    missing = set(required).difference(os.environ)
    if missing:
        raise ValueError(f'Environment variable not defined: {" ".join(missing)}')


def pipeline_status():
    url = 'https://gitlab.com/api/v4/projects/$CI_PROJECT_ID/pipelines?ref=$CHECK_BRANCH&per_page=1&page=$CHECK_PIPELINE'
    url = os.path.expandvars(url)
    response = urllib.request.urlopen(url)
    if response.status != 200:
        raise RuntimeError(f'HTTP {response.status}: {url}')
    pipeline = json.load(response)[0]
    return pipeline['status'], pipeline['web_url']


def main():
    check_environment()
    while True:
        status, url = pipeline_status()
        if status == 'running':
            sleep(1)
            continue
        elif status == 'success':
            break
        else:
            raise RuntimeError(f'Pipeline {status}: {url}')


if __name__ == '__main__':
    main()
