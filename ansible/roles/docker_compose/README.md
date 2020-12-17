# Create and manage Docker Compose projects

See `defaults/main.yml` for configurable parameters


## Notes on securing Docker networks

Docker may expose some containers to the nasty wide Internet:

- https://www.jeffgeerling.com/blog/2020/be-careful-docker-might-be-exposing-ports-world
- https://github.com/moby/moby/issues/22054

A workaround I plan to use is to never include `ports:` or `-p` with services
I'm not planning to expose.

Here is how it will look like:

```yaml
# application_stack/docker-compose.yml
version: '2.1'

services:
  web:  # no `ports` stuff here!
    image: nginx:latest
    networks:
      - web

networks:
  web:
    name: webnetwork  # Without explicit value a "$STACK_$NETWORK" will be used
                      # which is very inconvenient to refer to manually
    internal: yes     # Maybe containers in this project do not need Internet
                      # access at all?
```

```yaml
# ingress_stack/docker-compose.yaml
version: '2.4'

services:
  reverse-proxy:
    image: nginx
    ports:
      - '80:80'
    networks:
      - webnetwork    # A network with internal containers available via DNS names
      - default       # WAN

networks:
  webnetwork:         # Reference the name we assigned before
    external: yes     # Do not try to recreate the network, fail if it does not exist
                      # Because of this extra dependencies should be added on systemd level
```
