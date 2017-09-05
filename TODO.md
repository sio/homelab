# Migrate morebooks.ml to WootHosting VPS
[x] Obtain login credentials for new VPS
[x] Perform dist-upgrade
[x] Create a non-root user account
[x] Secure sshd acccess
[x] Configure locale (UTF-8)
[x] Set up git repo for common files
[x] Schedule daily package list update
    [x] Notify user about available updates
[x] Check ssh logs
    [-] Change sshd port or install fail2ban
[x] Check open ports, uninstall mail server
    [x] `ss -lnp` shows running network sevices
    [x] Do a `nmap` scan from outside
        [x] Deactivate 111/tcp: rpcbind
[x] Deactivate Telnet
[x] Firewall: ufw or iptables
    [x] Deny all incoming except ssh and www
[x] Install Python 3
[-] Check libsqlite3 version (>=3.8.11)
[x] Install Apache + mod_wsgi
[ ] Configure web server
    [ ] mod_security?
[ ] Move morebooks app and data
    [x] Install build dependencies for lxml and Pillow
[ ] Set up cron schedule for backups
[ ] Configure DNS for morebooks.ml
[x] Change timezone & setup ntp client
    [x] OpenVZ VPS share clock with host, no need
        for separate ntp client


# Hosting requirements
[x] Linux
[x] Python3 with pip
[x] WSGI-compatible web server
[x] Cron
[x] SSH access (non-root)
[x] Disk space: 1GB+
[x] RAM: 512MB+
[x] Custom domain name via CNAME
