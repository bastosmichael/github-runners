locals {
  docker_host_address = var.docker_host != "unix:///var/run/docker.sock" ? replace(replace(var.docker_host, "ssh://", ""), "${var.ssh_user}@", "") : "localhost"
}

output "portainer_url" {
  description = "URL to access Portainer"
  value       = var.enable_portainer ? "http://${local.docker_host_address}:9000" : "Portainer not enabled"
}

output "github_runner_stack" {
  description = "GitHub Actions runner stack status"
  value       = var.enable_github_runners ? "github-runner" : "GitHub runners not enabled"
}

output "deployed_stacks" {
  description = "List of deployed stacks"
  value = concat(
    var.enable_portainer ? ["portainer"] : [],
    var.enable_github_runners ? ["github-runner"] : []
  )
}
