# main.tf - исправленная версия
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

# Создание VPC сети
data "yandex_vpc_network" "main" {
  name = "default"  # Используем дефолтную сеть вместо создания новой
}

# Создание подсетей
resource "yandex_vpc_subnet" "public" {
  count          = length(var.public_subnet_cidrs)
  name           = "${var.project_name}-public-subnet-${count.index + 1}"
  zone           = var.availability_zones[0]
  network_id     = data.yandex_vpc_network.main.id
  v4_cidr_blocks = [var.public_subnet_cidrs[count.index]]
}

resource "yandex_vpc_subnet" "private" {
  count          = length(var.private_subnet_cidrs)
  name           = "${var.project_name}-private-subnet-${count.index + 1}"
  zone           = var.availability_zones[0]
  network_id     = data.yandex_vpc_network.main.id
  v4_cidr_blocks = [var.private_subnet_cidrs[count.index]]
}

# Группы безопасности
resource "yandex_vpc_security_group" "web" {
  name        = "${var.project_name}-web-sg"
  description = "Security group for web servers"
  network_id  = data.yandex_vpc_network.main.id

  ingress {
    description    = "HTTP"
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    description    = "HTTPS"
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  ingress {
    description    = "SSH"
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  egress {
    description    = "Outgoing traffic"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

resource "yandex_vpc_security_group" "app" {
  name        = "${var.project_name}-app-sg"
  description = "Security group for application servers"
  network_id  = data.yandex_vpc_network.main.id

  ingress {
    description    = "Application port"
    protocol       = "TCP"
    v4_cidr_blocks = [var.vpc_cidr]
    port           = 8080
  }

  ingress {
    description    = "PostgreSQL"
    protocol       = "TCP"
    v4_cidr_blocks = [var.vpc_cidr]
    port           = 5432
  }

  ingress {
    description    = "SSH"
    protocol       = "TCP"
    v4_cidr_blocks = [var.vpc_cidr]
    port           = 22
  }

  egress {
    description    = "Outgoing traffic"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

resource "yandex_vpc_security_group" "db" {
  name        = "${var.project_name}-db-sg"
  description = "Security group for databases"
  network_id  = data.yandex_vpc_network.main.id

  ingress {
    description    = "PostgreSQL"
    protocol       = "TCP"
    v4_cidr_blocks = [var.vpc_cidr]
    port           = 5432
  }

  egress {
    description    = "Outgoing traffic"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

# Диски для виртуальных машин
resource "yandex_compute_disk" "web_disk" {
  name     = "${var.project_name}-web-disk"
  type     = "network-ssd"
  zone     = var.availability_zones[0]
  image_id = data.yandex_compute_image.ubuntu.id
  size     = var.web_disk_size
}

resource "yandex_compute_disk" "app_disk" {
  name     = "${var.project_name}-app-disk"
  type     = "network-ssd"
  zone     = var.availability_zones[0]
  image_id = data.yandex_compute_image.ubuntu.id
  size     = var.app_disk_size
}

resource "yandex_compute_disk" "db_disk" {
  name     = "${var.project_name}-db-disk"
  type     = "network-ssd"
  zone     = var.availability_zones[0]
  image_id = data.yandex_compute_image.ubuntu.id
  size     = var.db_disk_size
}

# Дополнительные диски для данных
resource "yandex_compute_disk" "data_disk" {
  name = "${var.project_name}-data-disk"
  type = "network-ssd"
  zone = var.availability_zones[0]
  size = var.data_disk_size
}

resource "yandex_compute_disk" "backup_disk" {
  name = "${var.project_name}-backup-disk"
  type = "network-hdd"
  zone = var.availability_zones[0]
  size = var.backup_disk_size
}

# Виртуальные машины
resource "yandex_compute_instance" "web_server" {
  name               = "${var.project_name}-web-server"
  platform_id        = "standard-v3"
  zone               = var.availability_zones[0]

  resources {
    cores  = var.web_cpu_cores
    memory = var.web_memory
  }

  boot_disk {
    disk_id = yandex_compute_disk.web_disk.id
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public[0].id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.web.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }
}

resource "yandex_compute_instance" "app_server" {
  name               = "${var.project_name}-app-server"
  platform_id        = "standard-v3"
  zone               = var.availability_zones[0]

  resources {
    cores  = var.app_cpu_cores
    memory = var.app_memory
  }

  boot_disk {
    disk_id = yandex_compute_disk.app_disk.id
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private[0].id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.app.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }
}

resource "yandex_compute_instance" "db_server" {
  name               = "${var.project_name}-db-server"
  platform_id        = "standard-v3"
  zone               = var.availability_zones[0]

  resources {
    cores  = var.db_cpu_cores
    memory = var.db_memory
  }

  boot_disk {
    disk_id = yandex_compute_disk.db_disk.id
  }

  # Используем secondary_disk вместо disk_attachment
  secondary_disk {
    disk_id = yandex_compute_disk.data_disk.id
  }

  secondary_disk {
    disk_id = yandex_compute_disk.backup_disk.id
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private[0].id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.db.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }
}

# Service Account (упрощенная версия)

data "yandex_iam_service_account" "compute" {
  name = "alexeit315-sa"  # Используем существующий сервисный аккаунт
}