import os
import testinfra.utils.ansible_runner


testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_echo(host):
    cmd = host.run('echo hello')
    assert 'hello' in cmd.stdout


def test_authorized_keys(host):
    keys = host.file('/home/interactive/.ssh/authorized_keys')
    assert keys.contains('ssh-ed25519')
    assert keys.user == 'interactive'
    assert keys.mode == 0o600
    assert len(keys.content.splitlines()) == 1


def test_symlinks(host):
    vimrc = host.file('/home/interactive/.vimrc')
    assert vimrc.is_symlink
    assert vimrc.linked_to.endswith('dotfiles/vim/vimrc.link')
