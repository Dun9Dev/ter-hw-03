# Домашнее задание «Управляющие конструкции в коде Terraform»

## 🔗 Ссылка на репозиторий
[https://github.com/Dun9Dev/ter-hw-03/tree/terraform-03](https://github.com/Dun9Dev/ter-hw-03/tree/terraform-03)

## 🖼 Скриншоты

### 1. Группа безопасности — входящие правила (ingress)
![Группа безопасности](https://github.com/Dun9Dev/ter-hw-03/blob/terraform-03/img/Screenshot_4.png)

### 2. Ansible inventory.yml
![inventory.yml](https://github.com/Dun9Dev/ter-hw-03/blob/terraform-03/img/Screenshot_1.png)

## ✅ Выполненные задания

### Задание 1
- Сеть, подсеть и группа безопасности созданы.
- Скриншот входящих правил приложен.

### Задание 2
- `count-vm.tf`: созданы `web-1`, `web-2` с одинаковыми параметрами.
- `for_each-vm.tf`: созданы `main` и `replica` с разными параметрами через `for_each`.
- Использована переменная `each_vm` типа `list(object(...))`.
- `depends_on` гарантирует порядок создания.
- SSH-ключ подключён через `file("~/.ssh/id_ed25519.pub")`.

### Задание 3
- `disk_vm.tf`: созданы 3 диска через `count`.
- Одна ВМ `storage` подключает все диски через `dynamic secondary_disk`.

### Задание 4
- `ansible.tf` и `ansible.tpl`: сгенерирован `inventory.yml` с 3 группами.
- Инвентарь динамический, обрабатывает любое количество ВМ.
- Переменная `fqdn` передаётся для каждой ВМ.
