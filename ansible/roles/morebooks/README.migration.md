# Plans for moving to another hosting provider
### Provider candidates
- Aruba.it - recommended by multiple users at linux.org.ru (Cloud VPS Small -
  for 1 euro per month)
- Scaleway - 1.99 euro/month VPS. High quality, good reviews

### Reproducible setup and configuration
- [ ] Write ansible roles and playbooks
- [ ] Test setup in virtual machine / container


# DONE: Migrate morebooks.ml to WootHosting VPS (September 2017)
- [x] Obtain login credentials for new VPS
- [x] Operating system administration:
    - [x] Perform dist-upgrade
    - [x] Create a non-root user account
    - [x] Configure locale (UTF-8)
    - [x] Change timezone & setup ntp client
        - [x] OpenVZ VPS share clock with host, no need
            for separate ntp client
    - [x] Set up git repo for common files
    - [x] Schedule daily package list update
        - [x] Notify user about available updates
- [x] Security:
    - [x] Secure sshd acccess
    - [x] Check ssh logs
        - [-] Change sshd port or install fail2ban
    - [x] Check open ports, uninstall mail server
        - [x] `ss -lnp` shows running network sevices
        - [x] Do a `nmap` scan from outside
            - [x] Deactivate 111/tcp: rpcbind
            - [x] Deactivate telnet
    - [x] Firewall: ufw or iptables
        - [x] Deny all incoming except ssh and www
- [x] Morebooks application deployment:
    - [x] Install Python 3
    - [-] Check libsqlite3 version (>=3.8.11)
    - [x] Install Apache + mod_wsgi
    - [x] Configure web server
        - [-] mod_security?
    - [x] Move morebooks app and data
        - [x] Install build dependencies for lxml and Pillow
        - [x] Modify, test and run deployment script
        - [x] Copy data from the latest backup
- [x] Backup:
    - [x] Set up cron schedule for local backups
    - [x] Mirror backups to remote location
- [x] Test deployed application
- [x] Configure DNS for morebooks.ml and www.morebooks.ml
- [x] Enable SSL with Certbot (Let's Encrypt!)
    - [x] Allow https in firewall
    - [x] Make sure web server listens on port 443
    - [x] Enable ssl module in Apache
    - [x] Test web site with snakeoil certificate
    - [x] Try `certbot --staging --apache` until it works
    - [x] Delete fake certificates from --staging runs
    - [x] Run certbot to get a real certificate for both www and no-www
    - [x] Enable redirect from http to https
    - [x] Schedule certificate renewal with cron


# Hosting requirements
- [x] Linux
- [x] Python3 with pip
- [x] WSGI-compatible web server
- [x] Cron
- [x] SSH access (non-root)
- [x] Disk space: 1GB+
- [x] RAM: 512MB+
- [x] Custom domain name via CNAME
