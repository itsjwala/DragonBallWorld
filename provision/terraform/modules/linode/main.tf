resource "linode_instance" "node" {
  label           = var.node_label
  image           = "linode/ubuntu20.04"
  region          = "ap-west"
  type            = "g6-standard-2"
  authorized_keys = [linode_sshkey.itsjwala.ssh_key]
}

resource "linode_sshkey" "itsjwala" {
  label   = "terraform"
  ssh_key = chomp(file("~/.ssh/id_rsa.pub"))
}
