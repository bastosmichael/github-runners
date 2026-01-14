variable "docker_host" {
  description = "Docker daemon socket to connect to"
  type        = string
  default     = "unix:///var/run/docker.sock"
}

variable "ssh_user" {
  description = "SSH user for remote Docker host"
  type        = string
  default     = "michael"
}

variable "enable_portainer" {
  description = "Enable Portainer stack deployment"
  type        = bool
  default     = true
}

variable "enable_github_runners" {
  description = "Enable GitHub Actions runner stack deployment"
  type        = bool
  default     = true
}

variable "github_runner_org_url" {
  description = "GitHub organization URL (e.g., https://github.com/my-org)"
  type        = string
  default     = ""
}

variable "github_runner_token" {
  description = "GitHub Actions runner registration token"
  type        = string
  default     = ""
  sensitive   = true
}

variable "github_runner_count" {
  description = "Number of GitHub Actions runner containers to deploy"
  type        = number
  default     = 1
}

variable "github_runner_labels" {
  description = "Comma-separated labels for the runner"
  type        = string
  default     = "docker,ubuntu-22.04"
}

variable "github_runner_name_prefix" {
  description = "Prefix for runner names"
  type        = string
  default     = "github-runner"
}

variable "github_runner_version" {
  description = "GitHub Actions runner version to install"
  type        = string
  default     = "2.323.0"
}
