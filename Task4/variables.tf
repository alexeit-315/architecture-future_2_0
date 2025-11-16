variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "future-2-0"
}

#variable "yc_token" {
#  description = "Yandex Cloud OAuth token"
#  type        = string
#  sensitive   = true
#}
#
#variable "yc_cloud_id" {
#  description = "Yandex Cloud ID"
#  type        = string
#  sensitive   = true
#}
#
#variable "yc_folder_id" {
#  description = "Yandex Cloud Folder ID"
#  type        = string
#  sensitive   = true
#}

variable "default_zone" {
  description = "Default zone for resources"
  type        = string
  default     = "ru-central1-a"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["ru-central1-a"]
}

variable "web_cpu_cores" {
  description = "Number of CPU cores for web server"
  type        = number
  default     = 2
}

variable "web_memory" {
  description = "Memory for web server (GB)"
  type        = number
  default     = 4
}

variable "web_disk_size" {
  description = "Disk size for web server (GB)"
  type        = number
  default     = 50
}

variable "app_cpu_cores" {
  description = "Number of CPU cores for app server"
  type        = number
  default     = 4
}

variable "app_memory" {
  description = "Memory for app server (GB)"
  type        = number
  default     = 8
}

variable "app_disk_size" {
  description = "Disk size for app server (GB)"
  type        = number
  default     = 100
}

variable "db_cpu_cores" {
  description = "Number of CPU cores for db server"
  type        = number
  default     = 4
}

variable "db_memory" {
  description = "Memory for db server (GB)"
  type        = number
  default     = 16
}

variable "db_disk_size" {
  description = "Disk size for db server (GB)"
  type        = number
  default     = 500
}

variable "data_disk_size" {
  description = "Size of additional data disk (GB)"
  type        = number
  default     = 1000
}

variable "backup_disk_size" {
  description = "Size of backup disk (GB)"
  type        = number
  default     = 2000
}