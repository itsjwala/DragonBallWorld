data "template_file" "Caddyfile-internal" {
    template = file("${path.module}/conf/Caddyfile.internal")
}

data "template_file" "Caddyfile-external" {
    template = file("${path.module}/conf/Caddyfile.external")
    vars = {
        cloudflare_api_token = var.cloudflare_api_token
        fmd_domain_name      = var.fmd_domain_name
        aff1      = var.aff1
    }
}
