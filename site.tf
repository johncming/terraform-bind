variable "ip" {}

variable "port" {
  default = 2376
}

variable "bind_port" {
  default = 53
}

variable "web_port" {
  default = 10000
}

provider "docker" {
  host = "tcp://${var.ip}:${var.port}/"
}

resource "docker_image" "bind" {
  name = "sameersbn/bind:9.9.5-20170129"
}

resource "docker_container" "bind" {
  image = "${docker_image.bind.latest}"
  name  = "bind"

  ports {
    internal = 53
    external = "${var.bind_port}"
    protocol = "TCP"
  }


  ports {
    internal = 53
    external = "${var.bind_port}"
    protocol = "UDP"
  }

  ports {
    internal = 10000
    external = "${var.web_port}"
  }

  volumes {
    volume_name = "${docker_volume.bind.name}"
    container_path = "/data"
  }
}

resource "docker_volume" "bind" {
  name = "bind"
}
