# This script was adapted from Lucius Bono's project (MIT License)
# https://github.com/luciusbono/Packer-Windows10/blob/master/configure-winrm.ps1


# Related links in case this fails
# - WinRM commands can not be run under SYSTEM user
#   https://social.technet.microsoft.com/Forums/lync/en-US/40cd085f-9a71-47a1-825b-79bde4f13fb2/enable-winrm-on-unattended-installs?forum=winserverManagement
# - Enable-PSRemoting is a cmdlet that does more or less the same job
#   https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/enable-psremoting?view=powershell-7
# - Ansible docs for WinRM
#   https://docs.ansible.com/ansible/latest/user_guide/windows_setup.html
# - Chef scripts
#   https://github.com/chef/bento/blob/master/packer_templates/windows/scripts/base_setup.ps1
# - Packer documentation for Windows builds
#   https://www.packer.io/guides/automatic-operating-system-installs/autounattend_windows.html

# Install Qemu Balloon Service
b:\blnsvr.exe -i
sc.exe config balloonservice start= auto

# Change network type to Private to allow WinRM
Set-NetConnectionProfile -NetworkCategory Private

# Configure WinRM
winrm quickconfig -q
winrm s "winrm/config" '@{MaxTimeoutms="1800000"}'
winrm s "winrm/config/winrs" '@{MaxMemoryPerShellMB="2048"}'
winrm s "winrm/config/service" '@{AllowUnencrypted="true"}'  # will be disabled by Packer provisioner soon
winrm s "winrm/config/service/auth" '@{Basic="true"}'        # will be disabled by Packer provisioner soon

# Enable the WinRM Firewall rule, which will likely already be enabled due to the 'winrm quickconfig' command above
Enable-NetFirewallRule -DisplayName "Windows Remote Management (HTTP-In)"

# Restart service after reboot
sc.exe config winrm start= auto

# Disable automated login
Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -name AutoAdminLogon -value 0

exit 0
