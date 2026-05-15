<p align="center">
  <img alt="Caddy" src="/logo.webp" width="180">
</p>
<h1 align="center">
<a href="https://github.com/caddyserver/caddy-docker">Caddy</a> docker image
</h1>
<h3 align="center">
 Quick domain reverse proxy with auto-renewing SSL
</h3>
<p align="center">
<img alt="Release" src="https://img.shields.io/github/v/release/jinndi/caddy">
<img alt="Code size in bytes" src="https://img.shields.io/github/languages/code-size/jinndi/caddy">
<img alt="License" src="https://img.shields.io/github/license/jinndi/caddy">
<img alt="Actions Workflow Status" src="https://img.shields.io/github/actions/workflow/status/jinndi/caddy/build.yml">
<img alt="Visitor" src="https://hitscounter.dev/api/hit?url=https%3A%2F%2Fgithub.com%2Fjinndi%2Fcaddy&label=visitor&icon=eye&color=%230d6efd&message=&style=flat&tz=UTC">
</p>

## 🧩 Differences from the official image

- Setting up a reverse proxy using environment variables
- Supports only two architectures: linux/amd64 and linux/arm64

## 📋 Requirements

- Curl and Docker installed
- You need to have a domain name

## 🐳 Installation

### 1. Install Docker

If you haven't installed Docker yet, install it by running

```bash
curl -sSL https://get.docker.com | sh
sudo usermod -aG docker $(whoami)
```

### 2. Download docker compose file in curren dirrectory

```bash
curl -O https://raw.githubusercontent.com/jinndi/caddy/main/compose.yml
```

### 3. Fill in the environment variables using any convenient editor, for example nano

```bash
nano compose.yml
```

### 4. Setup Firewall

If you are using a firewall, you need to open `80` and `443` ports in `compose.yml`

### 5. Run compose.yml

From the same directory where you uploaded and configured compose.yml

```bash
docker compose up -d
```

> Stop: `docker compose down`, Update: `docker compose pull`, Logs: `docker compose logs`

## ⚙️ Options

| Env | Default | Description |
| :--- | :--- | :--- |
| `TZ` | - | Timezone. Useful for accurate logs and scheduling. Example: `Europe/Moscow` |
| `DOMAIN` | - | **Required.** Domain linked to your server's IP. |
| `EMAIL` | - | **Required.** Your email address, used when creating an ACME account with your CA (Let's Encrypt / ZeroSSL). |
| `PROXY_ROOT` | - | **Root Proxy Mode.** Address of a single backend (`<domain_or_ip>:<port>` or `<domain_or_ip>`) to proxy 100% of the domain's traffic. If set, `PROXY` and `PROXY_STRIP_PREFIX` are ignored. |
| `PROXY` | - | **Path Proxy Mode.** Addresses for the reverse proxy separated by commas. Format: `<domain_or_ip>:<port>/<prefix>` or `<domain_or_ip>`. The **prefix will be passed** to the backend itself. |
| `PROXY_STRIP_PREFIX` | - | **Path Proxy Mode.** Same as `PROXY`, except the **prefix will be stripped (removed)** before forwarding the request to the backend. |
| `LOG_LEVEL` | `info` | Log Level: `debug`, `info`, `warn`, `error`, `panic`, `fatal`  |

