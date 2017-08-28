# Migrate morebooks.ml to WootHosting VPS
[x] Obtain login credentials for new VPS
[x] Perform dist-upgrade
[x] Create a non-root user account
[x] Secure sshd acccess
[x] Set up git repo for common files
[ ] Check ssh logs
    [ ] Change sshd port or install fail2ban
[ ] Check open ports, uninstall mail server
    [ ] `ss -lnp` shows running network sevices
    [ ] Do a `nmap` scan from outside
        [ ] Deactivate 111/tcp: rpcbind
[ ] Deactivate Telnet
[ ] Firewall: ufw or iptables
    [ ] Deny all incoming except ssh and www
[ ] Install Python 3
[ ] Check libsqlite3 version (>=3.8.11)
[ ] Install Apache + mod_wsgi
[ ] Configure web server
    [ ] mod_security?
[ ] Move morebooks app and data
[ ] Set up cron schedule for backups
[ ] Configure DNS for morebooks.ml
