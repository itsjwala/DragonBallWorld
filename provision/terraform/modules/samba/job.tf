resource "nomad_job" "this" {
  jobspec = templatefile("${path.module}/conf/samba.nomad", {
    smb_conf =  data.template_file.samba_conf.rendered
  })
  
  hcl2 {
    enabled  = true
    allow_fs = true
  }

}
