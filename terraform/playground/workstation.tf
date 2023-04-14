variable "hostname" {
  type    = string
  default = "workstation"
}

resource "yandex_compute_instance" "workstation" {
  name        = var.hostname
  hostname    = var.hostname
  zone        = var.yc_zone
  platform_id = "standard-v3"
  resources {
    cores         = 4
    memory        = 8
    core_fraction = 20
  }
  boot_disk {
    auto_delete = true
    initialize_params {
      image_id = data.yandex_compute_image.debian.id
      size     = 25
    }
  }
  network_interface {
    subnet_id      = yandex_vpc_subnet.subnet.id
    nat            = true
    nat_ip_address = yandex_vpc_address.public.external_ipv4_address[0].address
  }
  scheduling_policy {
    preemptible = true
  }
  metadata = {
    serial-port-enable = 1
    user-data          = terraform_data.cloud_config.output
  }
  lifecycle {
    replace_triggered_by = [
      terraform_data.cloud_config
    ]
  }
}

resource "yandex_vpc_address" "public" {
  name = "${var.hostname}-ipv4"
  external_ipv4_address {
    zone_id = var.yc_zone
  }
}

resource "yandex_vpc_network" "network" {
  name = "${var.hostname}-net"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "${var.hostname}-subnet"
  v4_cidr_blocks = ["10.127.21.0/24"]
  network_id     = yandex_vpc_network.network.id
}

data "yandex_compute_image" "debian" {
  family = "debian-11"
}

resource "terraform_data" "cloud_config" {
  input = file("workstation.yml")
}

output "workstation_ip" {
  value = yandex_compute_instance.workstation.network_interface[0].nat_ip_address
}
