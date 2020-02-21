import os
import testinfra.utils.ansible_runner


testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_echo(host):
    cmd = host.run('echo hello')
    assert 'hello' in cmd.stdout


def test_installed(host):
    package = host.package('unattended-upgrades')
    assert package.is_installed


def test_configuration(host):
    filenames = [
        '/etc/apt/apt.conf.d/50unattended-upgrades',
        '/etc/apt/apt.conf.d/20auto-upgrades',
    ]
    for filename in filenames:
        config = host.file(filename)
        assert config.exists
        assert config.is_file
        assert config.size > 1
