resource "nomad_job" "this" {
    jobspec = templatefile("${path.module}/conf/wordpress.nomad",{
        fmd_db_user     = var.fmd_db_user
        fmd_db_name     = var.fmd_db_name
    })

    hcl2 {
        enabled  = true
        allow_fs = true
    }
}
