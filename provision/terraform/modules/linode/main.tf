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
  
  inbound {
    label    = "allow-http"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "80"
    ipv4     = ["0.0.0.0/0"]
  }

  inbound {
    label    = "allow-https"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "443"
    ipv4     = ["0.0.0.0/0"]
  }
  
  inbound {
    label    = "allow-everything"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "1-65535"
    ipv4     = ["100.0.0.0/8"]
  }
  
  inbound {
    label    = "allow-everything"
    action   = "ACCEPT"
    protocol = "UDP"
    ports    = "1-65535"
    ipv4     = ["100.0.0.0/8"]
  }

  inbound {
    label    = "allow-icmp"
    action   = "ACCEPT"
    protocol = "ICMP"
    ipv4     = ["100.0.0.0/8"]
  }

  inbound_policy = "DROP"

  outbound_policy = "ACCEPT"

  linodes = [linode_instance.node.id]
  depends_on = [ linode_instance.node ]
}
