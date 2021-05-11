job "samba" {
  datacenters = ["DragonBallWorld"]
  type        = "service"


  group "samba" {

    network {

      port "samba-port" {
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

    task "samba" {
      constraint {
        attribute = "$${attr.unique.hostname}"
        value     = "gohan"
      }

      driver = "docker"

      config {
        image = "ghcr.io/itsjwala/samba"

        // Bind the config file to container.
        mount {
          type   = "bind"
          source = "configs" // Bind mount the template from `NOMAD_TASK_DIR`
          target = "/etc/samba" 
        }

        // Bind the data directory to preserve certs.
        mount {
          type     = "bind"
          source   = "/mnt" # Bind mount the template from `NOMAD_TASK_DIR`
          target   = "/share"
          readonly = true
        }

        ports = ["samba-port"]
      }

      resources {
        cpu    = 200
        memory = 200
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
