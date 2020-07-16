# Wireguard VPN server or client

See `defaults/main.yml` for configuration parameters


## Useful links

- [Arch Wiki on Wireguard](https://wiki.archlinux.org/index.php/WireGuard) -
  see "Site to point" section, good tip on network-wide routes via router.
  Also contains good explanation of `allowed-ips` parameter.
- [Linode guide for Wireguard](https://www.linode.com/docs/networking/vpn/set-up-wireguard-vpn-on-ubuntu/) - generic step-by-step guide this role is based on
- [Ansible module:
  net_static_route](https://docs.ansible.com/ansible/latest/modules/net_static_route_module.html) -
  for configuring routes via VPN
    - NOTE: `wg-quick` should be pretty good at infering which routes to setup
      (see [man 8 wg-quick](https://manpages.debian.org/unstable/wireguard-tools/wg-quick.8.en.html))
