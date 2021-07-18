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
