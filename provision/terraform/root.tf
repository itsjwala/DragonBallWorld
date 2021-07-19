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
  fmd_wordpress_user      = var.fmd_wordpress_user
  fmd_wordpress_password  = var.fmd_wordpress_password
  fmd_wordpress_email     = var.fmd_wordpress_email

  providers = {
    nomad = nomad
  }
}

module "caddy" {
  source = "./modules/caddy"
  
  providers = {
    nomad = nomad
  }
}
