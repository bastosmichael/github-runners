variable "docker_host" {
  description = "Docker daemon socket to connect to"
  type        = string
  default     = "unix:///var/run/docker.sock"
}

variable "enable_portainer" {
  description = "Enable Portainer stack deployment"
  type        = bool
  default     = true
}

variable "enable_plex" {
  description = "Enable Plex stack deployment"
  type        = bool
  default     = false
}

variable "enable_jellyfin" {
  description = "Enable Jellyfin stack deployment"
  type        = bool
  default     = false
}

variable "enable_immich" {
  description = "Enable Immich stack deployment"
  type        = bool
  default     = false
}

variable "enable_navidrome" {
  description = "Enable Navidrome stack deployment"
  type        = bool
  default     = false
}

variable "enable_audiobookshelf" {
  description = "Enable Audiobookshelf stack deployment"
  type        = bool
  default     = false
}

variable "enable_nextcloud" {
  description = "Enable Nextcloud stack deployment"
  type        = bool
  default     = false
}

variable "enable_nginxproxymanager" {
  description = "Enable Nginx Proxy Manager stack deployment"
  type        = bool
  default     = false
}

variable "enable_startpage" {
  description = "Enable Startpage/Homepage stack deployment"
  type        = bool
  default     = false
}

variable "enable_vaultwarden" {
  description = "Enable Vaultwarden stack deployment"
  type        = bool
  default     = false
}

variable "enable_hoarder" {
  description = "Enable Hoarder stack deployment"
  type        = bool
  default     = false
}

variable "enable_docmost" {
  description = "Enable Docmost stack deployment"
  type        = bool
  default     = false
}

variable "enable_octoprint" {
  description = "Enable OctoPrint stack deployment"
  type        = bool
  default     = false
}

variable "enable_arrfiles" {
  description = "Enable Arrfiles/File Browser stack deployment"
  type        = bool
  default     = false
}

variable "enable_tautulli" {
  description = "Enable Tautulli stack deployment"
  type        = bool
  default     = false
}

variable "enable_overseerr" {
  description = "Enable Overseerr stack deployment"
  type        = bool
  default     = false
}

variable "enable_radarr" {
  description = "Enable Radarr stack deployment"
  type        = bool
  default     = false
}

variable "enable_sonarr" {
  description = "Enable Sonarr stack deployment"
  type        = bool
  default     = false
}

variable "enable_lidarr" {
  description = "Enable Lidarr stack deployment"
  type        = bool
  default     = false
}

variable "enable_bazarr" {
  description = "Enable Bazarr stack deployment"
  type        = bool
  default     = false
}

variable "enable_prowlarr" {
  description = "Enable Prowlarr stack deployment"
  type        = bool
  default     = false
}

variable "enable_qbittorrent" {
  description = "Enable qBittorrent stack deployment"
  type        = bool
  default     = false
}

variable "enable_nzbget" {
  description = "Enable NZBGet stack deployment"
  type        = bool
  default     = false
}

variable "enable_homeassistant" {
  description = "Enable Home Assistant stack deployment"
  type        = bool
  default     = false
}

variable "enable_zigbee2mqtt" {
  description = "Enable Zigbee2MQTT stack deployment"
  type        = bool
  default     = false
}

variable "enable_frigate" {
  description = "Enable Frigate NVR stack deployment"
  type        = bool
  default     = false
}

variable "enable_grafana" {
  description = "Enable Grafana stack deployment"
  type        = bool
  default     = false
}

variable "enable_influxdb" {
  description = "Enable InfluxDB stack deployment"
  type        = bool
  default     = false
}

variable "enable_prometheus" {
  description = "Enable Prometheus stack deployment"
  type        = bool
  default     = false
}
