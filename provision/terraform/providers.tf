provider "linode" {
  token = var.linode_token
}


provider "nomad" {
  address = "http://100.124.74.100:4646"
}
