module "node1" {
  source = "./modules/linode"
  providers = {
    linode = linode
  }
  node_label = "node1"
}

module "samba" {
  source = "./modules/samba"
  providers = {
    nomad = nomad
  }
}
