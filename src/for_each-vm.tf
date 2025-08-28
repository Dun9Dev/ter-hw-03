# Переменная с параметрами ВМ
variable "each_vm" {
  type = list(object({
    vm_name    = string
    cpu        = number
    ram        = number
    disk_size  = number
    disk_type  = string
  }))
  default = [
    {
      vm_name   = "main"
      cpu       = 2
      ram       = 2
      disk_size = 10
      disk_type = "network-hdd"
    },
    {
      vm_name   = "replica"
      cpu       = 2
      ram       = 1
      disk_size = 5
      disk_type = "network-ssd"
    }
  ]
}

# Создаём ВМ через for_each
resource "yandex_compute_instance" "db" {
  for_each = {
    for vm in var.each_vm : vm.vm_name => vm
  }

  name        = each.value.vm_name
  platform_id = "standard-v3"
  zone        = var.default_zone

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd86lblkag66uq48h63d" # ubuntu-2004-lts
      size     = each.value.disk_size
      type     = each.value.disk_type
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

  # Убедимся, что эти ВМ создаются ПОСЛЕ ВМ из count
  depends_on = [yandex_compute_instance.web]
}
