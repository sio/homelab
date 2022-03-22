# Cloudflare Argo tunnels

## Creating new tunnel

- [Cloudflare Docs](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide/)
- Short version:
    - On a separate machine install cloudflared and run:
      - `cloudflared login`
      - `cloudflared tunnel create $TUNNEL`
      - `cloudflared tunnel route dns $TUNNEL/$UUID $DOMAIN`
    - Copy required values from the generated json file to inventory
    - Remove login cert from the machine
