resource "nomad_job" "this" {
    jobspec = templatefile("${path.module}/conf/wordpress.nomad",{
        fmd_db_user             = var.fmd_db_user
        fmd_db_name             = var.fmd_db_name
        fmd_wordpress_user      = var.fmd_wordpress_user
        fmd_wordpress_password  = var.fmd_wordpress_password
        fmd_wordpress_email     = var.fmd_wordpress_email
    })

    hcl2 {
        enabled  = true
        allow_fs = true
    }
}
