resource "linode_instance" "node" {
  label           = var.node_label
  image           = "linode/ubuntu20.04"
  region          = "ap-west"
  type            = "g6-nanode-1"
  authorized_keys = [linode_sshkey.itsjwala.ssh_key]
}

resource "linode_sshkey" "itsjwala" {
  label   = "terraform"
  ssh_key = chomp(file("~/.ssh/id_rsa.pub"))
}


resource "linode_firewall" "my_firewall" {
  label = "my_firewall"

  inbound {
    label    = "allow-ssh"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = ["0.0.0.0/0"]
  }

  inbound_policy = "DROP"

  outbound_policy = "ACCEPT"

  linodes = [linode_instance.node.id]
  depends_on = [ linode_instance.node ]
}
