terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
    ssh = {
      source = "loafoe/ssh"
      version = "2.6.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Pulls the images
#resource "docker_image" "prometheus" {
#  name = "prom/prometheus:latest"
#}

# Create a container
resource "docker_container" "prometheus" {
  name  = "prometheus"
  image = "prom/prometheus:latest"
  user= "root"
  ports {
    internal = 9090
    external = 9090
  }
  volumes {
    container_path = "/etc/localtime"
    host_path = "/etc/localtime"
    read_only= true
  }
  command = ["--config.file=/etc/prometheus/prometheus.yml", "--log.level=error", "--storage.tsdb.path=/prometheus", "--storage.tsdb.max-block-duration=30m", "--storage.tsdb.min-block-duration=30m", "--web.enable-lifecycle"]
}

resource "docker_container" "grafana" {
  name = "grafana"
  image = "grafana/grafana:latest"
  restart = "unless-stopped"
  volumes {
    container_path = "/etc/localtime"
    host_path = "/etc/localtime"
    read_only= true
  }
  ports {
    internal = 3000
    external = 9000
  }
  env = [ 
    "GF_PATHS_CONFIG=/etc/grafana/grafana.ini",
    "GF_AUTH_GENERIC_OAUTH_ENABLED=true",
    "GF_AUTH_GENERIC_OAUTH_NAME=authentik",
    "GF_AUTH_GENERIC_OAUTH_CLIENT_ID=TCx47udijc4Q14Qqam0x1VcXb6lHLo7Uf90kfHnD",
    "GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET=YxAgTThk9USO9AOY1IcoCp2suGxTvQB4Udr08aR2KXMoFnI9awn569nUQjVqneD0mjH8JvrXpl94NUZd8IzB0npHVbCeogiOhMm6pd8OqwqIDLJjBAaEIoqHVhv8jaRk",
    "GF_AUTH_GENERIC_OAUTH_SCOPES=openid profile email",
    "GF_AUTH_GENERIC_OAUTH_AUTH_URL=https://authentik.bahl.fr/application/o/authorize/",
    "GF_AUTH_GENERIC_OAUTH_TOKEN_URL=https://authentik.bahl.fr/application/o/token/",
    "GF_AUTH_GENERIC_OAUTH_API_URL=https://authentik.bahl.fr/application/o/userinfo/",
    "GF_AUTH_SIGNOUT_REDIRECT_URL=https://authentik.bahl.fr/application/o/grafana-slug/end-session/",
    "Optionally enable auto-login (bypasses Grafana login screen)",
    "GF_AUTH_OAUTH_AUTO_LOGIN=true",
    #Optionally map user groups to Grafana roles
    "GF_AUTH_GENERIC_OAUTH_ROLE_ATTRIBUTE_PATH=\"contains(groups[*], 'Grafana Admin') && 'Admin' || contains(groups[*], 'Grafana Editors') && 'Editor' || 'Viewer'\"",
    "GF_PATHS_CONFIG=/etc/grafana/grafana.ini",
    "GF_AUTH_ANONYMOUS_ENABLED=false",
    "GF_AUTH_ANONYMOUS_ORG_ROLE=Admin",
    "GF_USERS_DEFAULT_THEME=dark",
    "GF_LOG_MODE=console",
    "GF_LOG_LEVEL=info",
    "GF_DASHBOARDS_DEFAULT_HOME_DASHBOARD_PATH=/etc/grafana/provisioning/dashboards/Host/node-exporter.json"
  ]
  provisioner "file" {
    source = "/home/masta/monitoring-swarm/grafana"
    destination = "/home/masta/test"
    connection {
      host = "192.168.1.100"
      user = "masta"
      private_key = file("/home/masta/.ssh/id_ed25519")
    }
  }
}

#resource "ssh_resource" "grafana" {
#  host = "asgard"
#  private_key = file("/home/masta/.ssh/id_ed25519")
#  file {
#    source = "/home/masta/monitoring-swarm/grafana/"
#    destination = "/home/masta/test/"
#    permissions = "0777"
#  }
#}
