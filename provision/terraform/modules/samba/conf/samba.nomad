job "samba-job" {
  datacenters = ["DragonBallWorld"]
  type        = "service"


  group "samba-group" {
    
    constraint {
      attribute = "$${attr.unique.hostname}"
      value     = "gohan"
    }

    network {

      port "samba-port-tailscale" {
        static = 445
        to     = 445
        host_network = "tailscale"
      }
      
      port "samba-port-default" {
        static = 445
        to     = 445
      }

    }

    restart {
      attempts = 2
      interval = "2m"
      delay    = "30s"
      mode     = "fail"
    }

    task "samba-task" {

      driver = "docker"

      config {
        image = "ghcr.io/itsjwala/samba"

        // Bind the config file to container.
        mount {
          type   = "bind"
          source = "configs" // Bind mount the template from `NOMAD_TASK_DIR`
          target = "/etc/samba" 
        }

        mount {
          type     = "bind"
          source   = "/media"
          target   = "/share"
          readonly = true
        }

        ports = ["samba-port-tailscale","samba-port-default"]
      }

      resources {
        cpu    = 200
        memory = 200
      }
      
      service {
        name = "samba-tailscale"
        tags =  ["samba"]
        port = "samba-port-tailscale"
        
        check {
          type     = "tcp"
          port     = "samba-port-tailscale"
          interval = "10s"
          timeout  = "2s"
        }

        // will decide if required differently for tailscale check port or not
        // check_restart {
        //     limit = 3
        //     grace = "90s"
        //     ignore_warnings = false
        // }

      }

      service {
        name = "samba-lan"
        tags =  ["samba"]
        port =  "samba-port-default"

        check {
          type     = "tcp"
          port     = "samba-port-default"
          interval = "10s"
          timeout  = "2s"
        }
        
      }

      template {
        data = <<EOF
        ${smb_conf}
        EOF

        destination = "configs/smb.conf" // Rendered template.

        // Caddy doesn't support reload via signals as of now
        change_mode = "restart"
      }
    }
  }
}
