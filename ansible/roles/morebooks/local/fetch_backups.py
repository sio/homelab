#!/usr/bin/env python3
"""
Fetch backups from remote server and deduplicate local copy
"""

REMOTE_SOURCE = '/home/hlc/data/backup/*'
REMOTE_USER = 'test'
REMOTE_HOST = '192.168.122.80'
REMOTE_KEY  = '/home/user/.ssh/morebooks-laptopmini'
LOCAL_DESTINATION = '/tmp/morebooks-backup/'


import os
from subprocess import Popen
from toolpot.scripting import remove_duplicates


def main():
    scp = Popen([
        'scp',
        '{user}@{host}:{path}'.format(
            user=REMOTE_USER,
            host=REMOTE_HOST,
            path=REMOTE_SOURCE,
        ),
        LOCAL_DESTINATION,
    ])
    if not scp.wait():
        remove_duplicates(LOCAL_DESTINATION)


if __name__ == '__main__':
    main()
