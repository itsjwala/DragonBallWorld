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

module "wordpress_fmd" {
  source = "./modules/wordpress"
  
  fmd_db_user     = var.fmd_db_user
  fmd_db_name     = var.fmd_db_name

  providers = {
    nomad = nomad
  }
}
