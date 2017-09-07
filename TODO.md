# Migrate morebooks.ml to WootHosting VPS
[x] Obtain login credentials for new VPS
[x] Operating system administration:
    [x] Perform dist-upgrade
    [x] Create a non-root user account
    [x] Configure locale (UTF-8)
    [x] Change timezone & setup ntp client
        [x] OpenVZ VPS share clock with host, no need
            for separate ntp client
    [x] Set up git repo for common files
    [x] Schedule daily package list update
        [x] Notify user about available updates
[x] Security:
    [x] Secure sshd acccess
    [x] Check ssh logs
        [-] Change sshd port or install fail2ban
    [x] Check open ports, uninstall mail server
        [x] `ss -lnp` shows running network sevices
        [x] Do a `nmap` scan from outside
            [x] Deactivate 111/tcp: rpcbind
            [x] Deactivate telnet
    [x] Firewall: ufw or iptables
        [x] Deny all incoming except ssh and www
[x] Morebooks application deployment:
    [x] Install Python 3
    [-] Check libsqlite3 version (>=3.8.11)
    [x] Install Apache + mod_wsgi
    [x] Configure web server
        [-] mod_security?
    [x] Move morebooks app and data
        [x] Install build dependencies for lxml and Pillow
        [x] Modify, test and run deployment script
        [x] Copy data from the latest backup
[x] Backup:
    [x] Set up cron schedule for local backups
    [ ] Mirror backups to remote location
[ ] Test deployed application
[ ] Configure DNS for morebooks.ml


# Hosting requirements
[x] Linux
[x] Python3 with pip
[x] WSGI-compatible web server
[x] Cron
[x] SSH access (non-root)
[x] Disk space: 1GB+
[x] RAM: 512MB+
[x] Custom domain name via CNAME
