data "template_file" "Caddyfile-internal" {
    template = file("${path.module}/conf/Caddyfile.internal")
}

data "template_file" "Caddyfile-external" {
    template = file("${path.module}/conf/Caddyfile.external")
}
