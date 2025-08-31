# Создаём 3 одинаковых диска по 1 ГБ
resource "yandex_compute_disk" "additional" {
  count = 3

  name        = "additional-disk-${count.index + 1}"
  type        = "network-hdd"
  zone        = var.default_zone
  size        = 1
}

# Создаём одну ВМ storage
resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = "standard-v3"
  zone        = var.default_zone

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

 boot_disk {
  initialize_params {
    image_id = data.yandex_compute_image.ubuntu.id
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

  # Подключаем дополнительные диски через dynamic и for_each
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.additional[*].id
    content {
      disk_id = secondary_disk.value
    }
  }
}
