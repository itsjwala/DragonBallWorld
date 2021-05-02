module "node1" {
  source = "./modules/linode"
  providers = {
    linode = linode
  }
  node_label = "node1"
}
