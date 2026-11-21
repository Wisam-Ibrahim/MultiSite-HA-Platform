terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

resource "local_file" "inventory" {
  filename = "${path.module}/../ansible/inventory.generated.ini"
  content  = templatefile("${path.module}/inventory.tftpl", { hosts = var.hosts, routers = var.routers })
}
