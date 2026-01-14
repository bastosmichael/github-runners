terraform {
  required_version = ">= 1.0"

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.2"
    }
  }
}

provider "null" {}

resource "null_resource" "bootstrap_docker" {
  triggers = {
    docker_host   = var.docker_host
    daemon_config = "v1"
  }

  provisioner "local-exec" {
    command = <<EOT
      USE_SSH=false
      if [[ "${var.docker_host}" == ssh://* ]]; then
        USE_SSH=true
        HOST="${replace(replace(var.docker_host, "ssh://", ""), "${var.ssh_user}@", "")}"
        USER="${var.ssh_user}"
      fi

      if [ "$USE_SSH" = "true" ]; then
        ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$USER@$HOST" 'bash -s' <<'REMOTE_SCRIPT'
          echo '{"default-address-pools":[{"base":"10.0.0.0/8","size":24}]}' | sudo tee /etc/docker/daemon.json > /dev/null
          sudo systemctl restart docker

          sudo mkdir -p /opt/portainer /opt/github-runner
          sudo chown -R 1000:1000 /opt/portainer /opt/github-runner || true
REMOTE_SCRIPT
      else
        echo '{"default-address-pools":[{"base":"10.0.0.0/8","size":24}]}' | sudo tee /etc/docker/daemon.json > /dev/null
        sudo systemctl restart docker

        sudo mkdir -p /opt/portainer /opt/github-runner
        sudo chown -R 1000:1000 /opt/portainer /opt/github-runner || true
      fi
    EOT
  }
}

resource "null_resource" "deploy_stacks" {
  depends_on = [null_resource.bootstrap_docker]

  triggers = {
    docker_host = var.docker_host

    enable_portainer      = var.enable_portainer
    enable_github_runners = var.enable_github_runners

    github_runner_count       = var.github_runner_count
    github_runner_org_url     = var.github_runner_org_url
    github_runner_token       = var.github_runner_token
    github_runner_labels      = var.github_runner_labels
    github_runner_name_prefix = var.github_runner_name_prefix
    github_runner_version     = var.github_runner_version

    portainer_compose_hash = filesha256("${path.module}/stacks/portainer/docker-compose.yml")

    github_runner_compose_hash    = filesha256("${path.module}/stacks/github-runner/docker-compose.yml")
    github_runner_dockerfile_hash = filesha256("${path.module}/stacks/github-runner/Dockerfile")
    github_runner_start_hash      = filesha256("${path.module}/stacks/github-runner/start.sh")
  }

  provisioner "local-exec" {
    command = <<EOT
      USE_SSH=false
      if [[ "${var.docker_host}" == ssh://* ]]; then
        USE_SSH=true
        HOST="${replace(replace(var.docker_host, "ssh://", ""), "${var.ssh_user}@", "")}"
        USER="${var.ssh_user}"
      fi

      if [ "$USE_SSH" = "true" ]; then
        scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/portainer/docker-compose.yml" "$USER@$HOST:/tmp/portainer.docker-compose.yml"
        scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/github-runner/docker-compose.yml" "$USER@$HOST:/tmp/github-runner.docker-compose.yml"
        scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/github-runner/Dockerfile" "$USER@$HOST:/tmp/github-runner.Dockerfile"
        scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/github-runner/start.sh" "$USER@$HOST:/tmp/github-runner.start.sh"

        ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$USER@$HOST" 'bash -s' <<'REMOTE_SCRIPT'
          set -e

          sudo mkdir -p /opt/portainer /opt/github-runner
          sudo chown -R 1000:1000 /opt/portainer /opt/github-runner || true

          sudo mv /tmp/portainer.docker-compose.yml /opt/portainer/docker-compose.yml
          sudo mv /tmp/github-runner.docker-compose.yml /opt/github-runner/docker-compose.yml
          sudo mv /tmp/github-runner.Dockerfile /opt/github-runner/Dockerfile
          sudo mv /tmp/github-runner.start.sh /opt/github-runner/start.sh
          sudo chmod +x /opt/github-runner/start.sh

          cat <<'ENV_FILE' | sudo tee /opt/github-runner/.env > /dev/null
GITHUB_ORG_URL=${var.github_runner_org_url}
GITHUB_TOKEN=${var.github_runner_token}
RUNNER_LABELS=${var.github_runner_labels}
RUNNER_NAME_PREFIX=${var.github_runner_name_prefix}
RUNNER_VERSION=${var.github_runner_version}
ENV_FILE
          echo "Configuring Firewall..."
          sudo ufw allow 22/tcp
          sudo ufw allow 8000/tcp
          sudo ufw allow 9000/tcp
          sudo ufw --force enable || true

          if [ "${var.enable_portainer}" = "true" ]; then
            cd /opt/portainer
            sudo docker compose up -d
          else
            echo "Skipping Portainer"
          fi

          if [ "${var.enable_github_runners}" = "true" ]; then
            cd /opt/github-runner
            sudo docker compose down --remove-orphans || true
            sudo docker compose up -d --build --scale github-runner=${var.github_runner_count}
          else
            echo "Skipping GitHub Runners"
          fi
REMOTE_SCRIPT
      else
        cp "${path.module}/stacks/portainer/docker-compose.yml" /tmp/portainer.docker-compose.yml
        cp "${path.module}/stacks/github-runner/docker-compose.yml" /tmp/github-runner.docker-compose.yml
        cp "${path.module}/stacks/github-runner/Dockerfile" /tmp/github-runner.Dockerfile
        cp "${path.module}/stacks/github-runner/start.sh" /tmp/github-runner.start.sh

        sudo mkdir -p /opt/portainer /opt/github-runner
        sudo chown -R 1000:1000 /opt/portainer /opt/github-runner || true

        sudo mv /tmp/portainer.docker-compose.yml /opt/portainer/docker-compose.yml
        sudo mv /tmp/github-runner.docker-compose.yml /opt/github-runner/docker-compose.yml
        sudo mv /tmp/github-runner.Dockerfile /opt/github-runner/Dockerfile
        sudo mv /tmp/github-runner.start.sh /opt/github-runner/start.sh
        sudo chmod +x /opt/github-runner/start.sh

        cat <<'ENV_FILE' | sudo tee /opt/github-runner/.env > /dev/null
GITHUB_ORG_URL=${var.github_runner_org_url}
GITHUB_TOKEN=${var.github_runner_token}
RUNNER_LABELS=${var.github_runner_labels}
RUNNER_NAME_PREFIX=${var.github_runner_name_prefix}
RUNNER_VERSION=${var.github_runner_version}
ENV_FILE

        if [ "${var.enable_portainer}" = "true" ]; then
          cd /opt/portainer
          sudo docker compose up -d
        else
          echo "Skipping Portainer"
        fi

        if [ "${var.enable_github_runners}" = "true" ]; then
          cd /opt/github-runner
          sudo docker compose down --remove-orphans || true
          sudo docker compose up -d --build --scale github-runner=${var.github_runner_count}
        else
          echo "Skipping GitHub Runners"
        fi
      fi
    EOT
  }
}
