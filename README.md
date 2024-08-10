# HomeLab

Personal homelab setup

## Prerequisites

- Docker
- Docker Compose
- SSH
- Ansible on the host machine
- Direnv (optional, issue `source .envrc` otherwise)
- Cloudflare account
- Domain name

## Usage

1. Setup nameservers for the domain:
    - Add Cloudflare nameservers to the domain registrar.
    - Add the domain to Cloudflare.
2. Setup Cloudflare Tunnel:
    - Create a tunnel for the domain.
    - Copy the tunnel ID and token.
3. Clone the repository:
    ```bash
    git clone <repository-url>
    cd <repository-directory>
    ```
4. Set up environment variables:
    - Create a `.envrc.local` file in the project root and populate it with the necessary values. Refer to the `.envrc`
      file for the required variables.
    - Load the environment variables using `direnv allow` or `source .envrc.local`.
5. Tweak docker service for cadvisor from [here](https://github.com/google/cadvisor/blob/master/docs/running.md), if you wish
   to avoid a non-root setup, update cgroup service in  [docker-compose.yml](docker-compose.yml) to run
   in `priviled: true` mode
6. Start the services:
    ```bash
     make deploy
    ```
7. Stop the services:
    ```bash
    make teardown
    ```

## Environment Variables

| Variable Name                      | Description                                         |
|------------------------------------|-----------------------------------------------------|
| `HOMELAB_IP`                       | IP address of the homelab                           |
| `HOMELAB_PORT`                     | Port for SSH access                                 |
| `HOMELAB_USER`                     | SSH user for the homelab                            |
| `HOMELAB_PASSWORD`                 | SSH password for the homelab                        |
| `HOMELAB_BECOME_USER`              | User to become for elevated privileges              |
| `HOMELAB_BECOME_PASSWORD`          | Password for the become user                        |
| `PROJECT_DIR`                      | Directory of the project on host machine            |
| `CLOUDFLARE_ACCOUNT_ID`            | Cloudflare account ID                               |
| `CLOUDFLARE_ACCOUNT_EMAIL_ADDRESS` | Cloudflare account email address                    |
| `CLOUDFLARE_DNS_API_TOKEN`         | Cloudflare DNS API token                            |
| `CLOUDFLARE_TUNNEL_ID`             | Cloudflare tunnel ID                                |
| `CLOUDFLARE_TUNNEL_TOKEN`          | Cloudflare tunnel token                             |
| `LETSENCRYPT_CA_SERVER`            | Let's Encrypt CA server URL (default is production) |
| `LETSENCRYPT_EMAIL_ADDRESS`        | Email address for Let's Encrypt                     |
| `ROOT_DOMAIN`                      | Root domain for the services                        |
| `GRAFANA_USER`                     | Grafana user                                        |
| `GRAFANA_PASSWORD`                 | Grafana password                                    |
| `GOOGLE_OAUTH_CLIENT_ID`           | Google OAuth client ID                              |
| `GOOGLE_OAUTH_CLIENT_SECRET`       | Google OAuth client secret                          |
| `SUPER_ADMIN_USERS`                | List of super admin user emails                     |
| `ADMIN_USERS`                      | List of admin user emails                           |
| `GUEST_USERS`                      | List of guest user emails                           |

## Services

| Service Name   | Description                                                                    | Access URL                         |
|----------------|--------------------------------------------------------------------------------|------------------------------------|
| `watchtower`   | Monitors and updates running Docker containers.                                |                                    |
| `nodeexporter` | Exports hardware and OS metrics.                                               |                                    |
| `cadvisor`     | Analyzes resource usage and performance characteristics of running containers. |                                    |
| `prometheus`   | Monitoring and alerting toolkit.                                               | `https://prometheus.<root_domain>` |
| `grafana`      | Analytics and monitoring platform.                                             | `https://grafana.<root_domain>`    |

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
