# Ansible thenets.nginx

Ansible role for Nginx + Steroids.

## Features

- Proxy to the another HTTP server
- Auto-generate Let's Encrypt certs and auto-renew
- Create reports using [goaccess](https://github.com/allinurl/goaccess)
- HTTP basic auth
- Custom config for each domain/subdomain

## Requirements

This role was tested only in the Ubuntu 18.04. Maybe it works in other Ubuntu and Debian versions.

- Ubuntu 18.04
- Open the `goaccess` stream port. (Default: 3030)

## Role Variables

TODO.

## Example Playbook

Example of how to use:

```yaml
---
- hosts: "my-nginx-hosts"
  remote_user: root
  roles:
  - role-nginx
  vars:
    # My servers list
    servers:
      front-end: "1.1.1.1"
      back-end:  "2.2.2.2"
      database:  "3.3.3.3"

    # GoAccess report
    goaccess:
      port: "3030" # this port must be publicly opened in firewall

    # HTTP Basic Auth
    auth:
      # Developer accounts
      - keychain: "dev-accounts"
        user: "myUs3r"
        pass: "myP4ss"
      - keychain: "dev-accounts"
        user: "cafe"
        pass: "chocolate"
      # Sysadmin accounts
      - keychain: "sys-accounts"
        user: "dante"
        pass: "pizza"

    # ACME Let's Encrypt
    acme_email: my-email@mail.com

    # Nginx load balancer config
    loadbalancer_sites:
      # Simple proxy
      - domain: "unsecure.example.com"
        proxy_to: "http://{{servers.front-end}}:8080"

      # Simple permanent redirect
      - domain: "temp.example.com"
        location_extra: |
          rewrite ^ https://www.example.com? permanent;

      # Proxy using HTTPS
      #
      # The 'https://app.example.com' will proxy to
      # a server without SSL.
      - domain: "app.example.com"
        proxy_to: "http://{{servers.front-end}}:8200"
        ssl: true

      # Add HTTP auth
      #
      # Only 'sys-accounts' users have access.
      - domain: "jenkins.example.com"
        proxy_to: "http://{{servers.back-end}}:8080"
        auth_keychain: "sys-accounts"

      # Custom template: goaccess
      #
      # Generate real-time report from Nginx logs.
      - domain: "stats.example.com"
        template: "goaccess"

      # Add custom config
      - domain: "blocked.example.com"
        proxy_to: "http://{{servers.front-end}}:8080"
        server_extra: |
          server_name   anotherblocked.example.com;
        location_extra: |
          gzip off;
          add_header X-Robots-Tag "noindex, follow" always;
```

## License

MIT

## Author Information

If you have any question contact me at IRC Freenode at #thenets-opensource channel.

Or check my other contact info at https://www.thenets.org/contact .
