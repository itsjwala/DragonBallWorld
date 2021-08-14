resource "nomad_job" "this" {
  jobspec = file("${path.module}/conf/adguard.nomad")
  
  hcl2 {
    enabled  = true
    allow_fs = true
  }

}
