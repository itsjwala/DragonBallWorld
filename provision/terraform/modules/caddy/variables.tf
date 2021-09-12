variable "cloudflare_api_token" {
  type        = string
  sensitive   = true
  description = "Cloudflare API token to edit DNS Zones and Records."
}

variable "fmd_domain_name" {
  type        = string
  sensitive   = true
  description = "fmd domain name"
}

variable "aff1" {
  type        = string
  sensitive   = true
  description = "aff1 domain name"
}
