resource "nomad_job" "this" {
  jobspec = templatefile("${path.module}/conf/caddy.nomad", {
    caddyfile_internal =  data.template_file.Caddyfile-internal.rendered
    caddyfile_external  =  data.template_file.Caddyfile-external.rendered
  })
  
  hcl2 {
    enabled  = true
    allow_fs = true
  }

}
