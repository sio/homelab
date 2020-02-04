import os
import testinfra.utils.ansible_runner


testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_echo(host):
    cmd = host.run('echo hello')
    assert 'hello' in cmd.stdout


def test_installed(host):
    package = host.package('transmission-daemon')
    assert package.is_installed
    assert package.version == '2.94-2.1'
