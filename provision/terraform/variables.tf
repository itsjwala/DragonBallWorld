variable "linode_token" {
  type        = string
  sensitive   = true
  description = "API token for linode terraform"

}

variable "fmd_db_user" {
  type        = string
  sensitive   = true
  description = "fmd db user"
}

variable "fmd_db_name" {
  type        = string
  sensitive   = true
  description = "fmd db name"
}

variable "fmd_wordpress_user" {
  type        = string
  sensitive   = true
  description = "fmd wordpress user"
}

variable "fmd_wordpress_password" {
  type        = string
  sensitive   = true
  description = "fmd wordpress password"
}

variable "fmd_wordpress_email" {
  type        = string
  sensitive   = true
  description = "fmd wordpress email"
}
