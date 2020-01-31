import os
import testinfra.utils.ansible_runner


testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_echo(host):
    cmd = host.run('echo hello')
    assert 'hello' in cmd.stdout


def test_motd(host):
    motd = host.file('/etc/motd')
    for line in ('BEGIN', 'END', 'special snowflake', 'MANAGED REMOTELY WITH ANSIBLE'):
        assert motd.contains(line)
