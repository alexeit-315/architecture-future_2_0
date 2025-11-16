output "vpc_network_id" {
  value = data.yandex_vpc_network.main.id
}

output "subnet_ids" {
  value = {
    public  = yandex_vpc_subnet.public[*].id
    private = yandex_vpc_subnet.private[*].id
  }
}

output "security_group_ids" {
  value = {
    web = yandex_vpc_security_group.web.id
    app = yandex_vpc_security_group.app.id
    db  = yandex_vpc_security_group.db.id
  }
}

output "instance_ids" {
  value = {
    web = yandex_compute_instance.web_server.id
    app = yandex_compute_instance.app_server.id
    db  = yandex_compute_instance.db_server.id
  }
}
