variable "hosts" {
  type = map(object({
    ip         = string
    user       = string
    site       = string
    vrrp_if    = string
    vrrp_state = string
    vrrp_prio  = number
  }))
  default = {
    "ms-site-a-01" = { ip = "192.168.16.101", user = "admin11", site = "site_a", vrrp_if = "ens37", vrrp_state = "MASTER", vrrp_prio = 150 }
    "ms-site-a-02" = { ip = "192.168.16.102", user = "ms-site-a-02", site = "site_a", vrrp_if = "ens33", vrrp_state = "BACKUP", vrrp_prio = 100 }
    "ms-site-b-01" = { ip = "192.168.16.103", user = "ms-site-b-01", site = "site_b", vrrp_if = "ens33", vrrp_state = "BACKUP", vrrp_prio = 90 }
  }
}

variable "routers" {
  type    = list(string)
  default = ["ms-site-a-01", "ms-site-b-01"]
}
