terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# Создаем сеть
resource "docker_network" "monitoring" {
  name = "monitoring"
}

# Prometheus контейнер
resource "docker_container" "prometheus" {
  image = "prom/prometheus:latest"
  name  = "prometheus"
  restart = "always"
  networks_advanced {
    name = docker_network.monitoring.name
  }
  ports {
    internal = 9090
    external = 9090
  }
  volumes {
    host_path = "/Users/satimur/Documents/Projects/terraform-grafana/prometheus.yml"
    container_path = "/etc/prometheus/prometheus.yml"
  }
}

# Grafana контейнер
resource "docker_container" "grafana" {
  image = "grafana/grafana:latest"
  name  = "grafana"
  restart = "always"
  networks_advanced {
    name = docker_network.monitoring.name
  }
  ports {
    internal = 3000
    external = 3000
  }
  volumes {
    host_path = "/Users/satimur/Documents/Projects/terraform-grafana/grafana-storage/grafana-storage"
    container_path = "/var/lib/grafana"
  }
}
