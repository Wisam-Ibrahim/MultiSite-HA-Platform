variable "hosts" {
  type = map(object({
    ip   = string
    user = string
    site = string
  }))
  default = {
    "ms-site-a-01" = { ip = "192.168.16.101", user = "admin11", site = "site_a" }
    "ms-site-a-02" = { ip = "192.168.16.102", user = "ms-site-a-02", site = "site_a" }
    "ms-site-b-01" = { ip = "192.168.16.103", user = "ms-site-b-01", site = "site_b" }
  }
}

variable "routers" {
  type    = list(string)
  default = ["ms-site-a-01", "ms-site-b-01"]
}
