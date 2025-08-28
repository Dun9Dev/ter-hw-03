# Создаём 2 одинаковые ВМ: web-1 и web-2
resource "yandex_compute_instance" "web" {
  count        = 2
  name         = "web-${count.index + 1}"
  platform_id  = "standard-v3"
  zone         = var.default_zone

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd86lblkag66uq48h63d" # ubuntu-2004-lts
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id         = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id]
    nat               = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}
