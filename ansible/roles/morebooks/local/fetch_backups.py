#!/usr/bin/env python3
"""
Fetch backups from remote server and deduplicate local copy

All dependencies are packaged for Debian (except for toolpot):
    - python3-paramiko
    - python3-scp
"""

REMOTE_SOURCE = '/home/hlc/data/backup/*'
REMOTE_USER = 'test'
REMOTE_HOST = 'test-vm'
REMOTE_PORT = 22
LOCAL_DESTINATION = '/tmp/morebooks-backup/'


from toolpot.scripting import remove_duplicates
from paramiko import SSHClient
from scp import SCPClient


def main():
    ssh = SSHClient()
    ssh.load_system_host_keys()
    ssh.connect(REMOTE_HOST, username=REMOTE_USER)
    with SCPClient(ssh.get_transport()) as scp:
        scp.get(
            REMOTE_SOURCE,
            LOCAL_DESTINATION,
            recursive=True,
            preserve_times=True,
        )
    ssh.close()

    remove_duplicates(LOCAL_DESTINATION)


if __name__ == '__main__':
    main()
