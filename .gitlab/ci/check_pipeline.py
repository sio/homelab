#!/usr/bin/env python3
'''
Translate status of previous CI pipeline into exit code

Wait for the previous pipeline to finish if it's still running
'''


import json
import os
import urllib.request
from datetime import datetime
from time import sleep


GITLAB_API = 'https://gitlab.com/api/v4'


def check_environment():
    required = ['CI_PROJECT_ID', 'CHECK_BRANCH', 'CI_PIPELINE_ID']
    missing = set(required).difference(os.environ)
    if missing:
        raise ValueError(f'Environment variable not defined: {" ".join(missing)}')


def fetch_json(url):
    response = urllib.request.urlopen(url)
    if response.status != 200:
        raise RuntimeError(f'HTTP {response.status}: {url}')
    return json.load(response)


def find_previous_pipeline(project_id, find_previous=1, branch='master', current_pipeline_id=None):
    if current_pipeline_id is None:
        current_pipeline_id = int(os.environ['CI_PIPELINE_ID'])
    url = f'{GITLAB_API}/projects/{project_id}/pipelines?ref={branch}'
    pipelines = fetch_json(url)

    relative_idx = -1
    for pipeline in sorted(pipelines,
                           key=lambda p: datetime.fromisoformat(p['created_at'][:-1]),
                           reverse=True):
        if relative_idx >= 0:
            relative_idx += 1
        if pipeline['id'] == current_pipeline_id:
            relative_idx = 0
        if relative_idx == find_previous:
            return pipeline
    else:
        raise RuntimeError(f'Current or previous pipeline not found among {len(pipelines)} newest pipelines')


def pipeline_status(project_id, pipeline_id):
    url = f'{GITLAB_API}/projects/{project_id}/pipelines/{pipeline_id}'
    pipeline = fetch_json(url)
    return pipeline['status']


def main():
    check_environment()
    project = int(os.environ['CI_PROJECT_ID'])
    branch = os.environ['CHECK_BRANCH']
    pipeline = find_previous_pipeline(project, branch=branch)
    while True:
        status = pipeline_status(project, pipeline['id'])
        if status == 'running':
            sleep(2)
            continue
        elif status == 'success':
            break
        else:
            raise RuntimeError(f'Pipeline {status}: {pipeline["web_url"]}')


if __name__ == '__main__':
    main()
