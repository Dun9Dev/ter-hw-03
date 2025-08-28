# Генерируем inventory.yml для Ansible
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/ansible.tpl", {
    webservers = [
      for vm in yandex_compute_instance.web : {
        name       = vm.name
        external_ip = vm.network_interface[0].nat_ip_address
        fqdn       = vm.fqdn
      }
    ]
    databases = [
      for vm_key, vm_value in yandex_compute_instance.db : {
        name       = vm_value.name
        external_ip = vm_value.network_interface[0].nat_ip_address
        fqdn       = vm_value.fqdn
      }
    ]
    storage = [
      {
        name       = yandex_compute_instance.storage.name
        external_ip = yandex_compute_instance.storage.network_interface[0].nat_ip_address
        fqdn       = yandex_compute_instance.storage.fqdn
      }
    ]
  })
  filename = "${path.module}/inventory.yml"
}
