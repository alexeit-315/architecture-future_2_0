project_name = "future-2-0"

# Network configuration
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24"]
private_subnet_cidrs = ["10.0.2.0/24"]

# Instance configuration
web_cpu_cores = 2
web_memory    = 4
web_disk_size = 50

app_cpu_cores = 4
app_memory    = 8
app_disk_size = 50

db_cpu_cores = 4
db_memory    = 16
db_disk_size = 50

# Additional disks
data_disk_size   = 10
backup_disk_size = 2000