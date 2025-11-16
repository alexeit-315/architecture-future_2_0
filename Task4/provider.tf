terraform {
  required_version = ">= 1.0"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.108.1"
    }
  }
}

provider "yandex" {
  service_account_key_file = "sa-key.json"
  cloud_id  = "b1gfn5fsufp4jgnf0ujd"
  folder_id = "b1gamjqs55gt5759ponq"
  zone      = "ru-central1-a"
}