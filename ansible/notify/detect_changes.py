#!/usr/bin/env python3
'''
Detect changed tasks in Ansible playbook output

Exit with a non-zero code if any changes detected which were not specifically
allowed to be ignored
'''


import json
import os
import re
import sys
from collections import defaultdict
from itertools import chain


def drop_colors(text, _color_regex=re.compile('\x1b' r'\[(?:(?:\d{0,3};?){1,4}m|K)')):
    '''Drop ASCII color code sequences from text'''
    return _color_regex.sub('', text)


def playbook_parse(ansible_stdout,
        _task_regex=re.compile(r'^(?:TASK|RUNNING HANDLER) \[(.*)\]'),
        _status_regex=re.compile(r'^([a-z]+): \[([^\]]+)\]'),
        _EOF='***EOF***EOF***EOF***'):
    '''Parse Ansible stdout in a single pass'''
    tasks = []
    task_name = None
    host_status = None

    lines = drop_colors(ansible_stdout).splitlines()
    for line in chain(lines, [_EOF]):
        task_match = _task_regex.search(line)
        if task_match or line == _EOF:
            if task_name:
                tasks.append({task_name: dict(host_status)})
            if line == _EOF:
                continue
            host_status = defaultdict(set)
            task_name = task_match.group(1)
            continue

        status_match = _status_regex.search(line)
        if status_match:
            status, host = status_match.group(1, 2)
            host_status[status].add(host)
            continue
    return tasks


def check_status(ansible_stdout, **kw):
    '''Check if Ansible stdout contains any tasks with specified status'''
    return _check_status(ansible_stdout, return_early=True, **kw)


def find_status(ansible_stdout, **kw):
    '''Find all tasks with specified status'''
    return _check_status(ansible_stdout, return_early=False, **kw)


def _check_status(ansible_stdout, status='changed', skip=None, return_early=True):
    if skip is None:
        skip = {}
    found = []
    for task in playbook_parse(ansible_stdout):
        task_name = next(iter(task.keys()))
        host_status = next(iter(task.values()))
        if status in host_status:
            if task_name in skip.get('all', []):
                continue
            if all(task_name in skip.get(host, []) for host in host_status[status]):
                continue
            if return_early:
                return True
            found.append(task)
    if return_early:
        return False
    return found


class JsonEncoderWithSets(json.JSONEncoder):
    '''Encode Python sets as JSON lists'''
    def default(self, obj):
        if isinstance(obj, set):
            return list(obj)
        return json.JSONEncoder.default(self, obj)


def main():
    '''Script entrypoint'''
    with open(sys.argv[1]) as log:
        log_stdout = log.read()

    skip_filename = os.environ.get('ALLOWED_CHANGES_LIST')
    skip = None
    if skip_filename:
        with open(skip_filename) as skip_file:
            skip = json.load(skip_file)

    if check_status(log_stdout, skip=skip):
        print(json.dumps(
            find_status(log_stdout, skip=skip),
            indent=2,
            ensure_ascii=False,
            cls=JsonEncoderWithSets
        ))
        sys.exit(1)


if __name__ == '__main__':
    main()
