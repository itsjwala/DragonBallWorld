data "template_file" "samba_conf" {
    template = file("${path.module}/conf/smb.conf")
}
