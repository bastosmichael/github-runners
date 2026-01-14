# GitHub Runners

This project manages a GitHub Actions runner host using Terraform and Docker, plus a Portainer UI for container management.

## Project Structure
```
infra/            # Terraform configuration
  bootstrap.sh    # Manual bootstrap script (optional)
  main.tf         # Main Terraform logic
  variables.tf    # Variable definitions
  outputs.tf      # Deployment outputs
  stacks/         # Docker Compose files grouped by purpose
    github-runner/  # GitHub Actions runner container build + entrypoint
    portainer/      # Portainer UI
```

## Prerequisites
- You must be an organization owner or have appropriate permissions to manage runners at the organization level.
- You need a server/VM with Docker installed.
- You will generate a Personal Access Token (PAT) or use a time-limited token from the GitHub UI for authentication.

## Step-by-Step Guide
### 1. Add the Runner to Your GitHub Organization
1. Navigate to your organization’s settings on GitHub.
2. In the left sidebar, click **Actions**, then click **Runners**.
3. Click **New self-hosted runner**.
4. Select the operating system (Linux) and architecture (x64).
5. Copy the time-limited token shown in the configuration command; you will use it in Terraform.

> **Important:** A single runner instance can only be registered to one scope (repository, organization, or enterprise) at a time. To share a runner across multiple repositories, register it at the organization level.

### 2. Deploy the Docker Environment with Terraform
Terraform copies a Dockerfile and start script to your server, builds the image, and starts the runner containers.

```bash
cd infra
terraform init
terraform apply \
  -var="docker_host=ssh://michael@192.168.86.42" \
  -var="ssh_user=michael" \
  -var="enable_portainer=true" \
  -var="enable_github_runners=true" \
  -var="github_runner_org_url=https://github.com/your-org" \
  -var="github_runner_token=YOUR_REGISTRATION_TOKEN" \
  -var="github_runner_count=1"
```

**Note:** replace `192.168.86.42` with your actual server IP.

### 3. Verify and Use
- Verify the runner is online: **Organization Settings → Actions → Runners**. Your new runner should be listed and show a green status icon (Idle).
- Use the runner in workflows by matching its labels:

```yaml
jobs:
  build:
    runs-on: [self-hosted, docker, ubuntu-22.04]
    steps:
      - uses: actions/checkout@v4
```

## Accessing Portainer
- **Portainer:** `http://<server-ip>:9000`

## System Prerequisites
Before running Terraform, ensure:
1. **SSH Access:** Keys are copied to the server (`ssh-copy-id`).
2. **Passwordless Sudo:** The user must be able to run sudo without a password for Terraform automation.
   Run this on the server (or via SSH) once:
   ```bash
   ssh -t michael@<server-ip> "echo 'michael ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/michael"
   ```

## Checking Logs
To check the logs of the GitHub runner containers, SSH into the server and run:

```bash
ssh michael@192.168.86.42 "sudo docker compose -f /opt/github-runner/docker-compose.yml logs -f"
```
