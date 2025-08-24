variable "auth_url" {}
variable "user_name" {}
variable "password" { sensitive = true }
variable "tenant_name" {}
variable "region" { default = "RegionOne" }

variable "image_name" { default = "Ubuntu 22.04" }
variable "flavor_master" { default = "m1.medium" }
variable "flavor_worker" { default = "m1.small" }
variable "network_name" { default = "private" }
variable "keypair" {}

variable "worker_count" { default = 2 }
