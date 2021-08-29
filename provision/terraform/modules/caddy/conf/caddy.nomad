job "caddy" {
  datacenters = ["DragonBallWorld"]
  type        = "service"

  group "gohan-internal" {
    count = 1
    
    constraint {
      attribute = "$${attr.unique.hostname}"
      value     = "gohan"
    }

    network {
      port "http-internal" {
        static       = 80
        to           = 80
        host_network = "tailscale"
      }

      port "https-internal" {
        static       = 443
        to           = 443
        host_network = "tailscale"
      }

      port "healthcheck" {
        to           = 8080
        host_network = "tailscale"
      }

    }

    task "make_sure_mount_directories_exists" {
      lifecycle {
        hook = "prestart"
        sidecar = false
      }

      driver = "raw_exec"
      config {
        command = "sh"
        args = ["-c", "mkdir -p /opt/caddy && chown nobody:nogroup /opt/caddy"]
      }

      resources {
        cpu    = 1
        memory = 10
      }
      
    }

    task "proxy" {

      driver = "docker"

      config {
        image = "ghcr.io/itsjwala/caddy"

        # Bind the config file to container.
        mount {
          type   = "bind"
          source = "configs" # Bind mount the template from `NOMAD_TASK_DIR`
          target = "/etc/caddy"
        }

        # Bind the data directory to preserve certs.
        mount {
          type     = "bind"
          source   = "/opt/caddy"
          target   = "/data"
          readonly = false
        }

        ports = ["http-internal", "https-internal", "healthcheck"]
      }

      resources {
        cpu    = 100
        memory = 50
      }

      template {
        data = <<EOF
        ${caddyfile_internal}
        EOF

        destination = "configs/Caddyfile" # Rendered template.

        # Caddy doesn't support reload via signals as of now
        change_mode = "restart"
      }

      service {
        name = "gohan-caddy"
        tags = ["caddy", "proxy"]
        
        check {
          name      = "caddy server health check"
          type      = "http"
           path     = "/health-check"
          port      =  "healthcheck"
          interval  = "10s"
          timeout   = "2s"
        }
      }
    }

  }
/*
  group "goku-external" {
    
    constraint {
      attribute = "$${attr.unique.hostname}"
      value     = "goku"
    }

    network {

      port "https-external" {
        static = 80
        to     = 80
      }

      port "http-external" {
        static = 443
        to     = 443
      }
      port "healthcheck" {
        to     = 8080
      }
    }

    restart {
      attempts = 2
      interval = "2m"
      delay    = "30s"
      mode     = "fail"
    }

    task "make_sure_mount_directories_exists" {
      lifecycle {
        hook = "prestart"
        sidecar = false
      }

      driver = "raw_exec"
      config {
        command = "sh"
        args = ["-c", "mkdir -p /opt/caddy && chown nobody:nogroup /opt/caddy"]
      }
      
      resources {
        cpu    = 1
        memory = 10
      }

    }

    task "proxy" {

      driver = "docker"

      config {
        image = "ghcr.io/itsjwala/caddy:amd64"

        # Bind the config file to container.
        mount {
          type   = "bind"
          source = "configs" # Bind mount the template from `NOMAD_TASK_DIR`
          target = "/etc/caddy" 
        }

        # Bind the data directory to preserve certs.
        mount {
          type     = "bind"
          source   = "/opt/caddy"
          target   = "/data"
          readonly = false
        }

        ports = ["http-external", "https-external", "healthcheck"]
      }

      resources {
        cpu    = 100
        memory = 50
      }

      template {
        data = <<EOF
        ${caddyfile_external}
        EOF

        destination = "configs/Caddyfile" # Rendered template.

        # Caddy doesn't support reload via signals as of now
        change_mode = "restart"
      }

      service {
        name = "goku-caddy"
        tags = ["caddy", "proxy"]
        
        check {
          name      = "caddy server health check"
          type      = "http"
           path     = "/health-check"
          port      =  "healthcheck"
          interval  = "10s"
          timeout   = "2s"
        }
      }

    }
  }
*/
  group "piccolo-external" {
    
    constraint {
      attribute = "$${attr.unique.hostname}"
      value     = "piccolo"
    }

    network {

      port "https-external" {
        static = 80
        to     = 80
      }

      port "http-external" {
        static = 443
        to     = 443
      }
      port "healthcheck" {
        to     = 8080
      }
    }

    restart {
      attempts = 2
      interval = "2m"
      delay    = "30s"
      mode     = "fail"
    }

    task "make_sure_mount_directories_exists" {
      lifecycle {
        hook = "prestart"
        sidecar = false
      }

      driver = "raw_exec"
      config {
        command = "sh"
        args = ["-c", "mkdir -p /opt/caddy && chown nobody:nogroup /opt/caddy"]
      }
      
      resources {
        cpu    = 1
        memory = 10
      }

    }

    task "proxy" {

      driver = "docker"

      config {
        image = "ghcr.io/itsjwala/caddy:amd64"

        # Bind the config file to container.
        mount {
          type   = "bind"
          source = "configs" # Bind mount the template from `NOMAD_TASK_DIR`
          target = "/etc/caddy" 
        }

        # Bind the data directory to preserve certs.
        mount {
          type     = "bind"
          source   = "/opt/caddy"
          target   = "/data"
          readonly = false
        }

        ports = ["http-external", "https-external", "healthcheck"]
      }

      resources {
        cpu    = 100
        memory = 50
      }

      template {
        data = <<EOF
        ${caddyfile_external}
        EOF

        destination = "configs/Caddyfile" # Rendered template.

        # Caddy doesn't support reload via signals as of now
        change_mode = "restart"
      }

      service {
        name = "piccolo-caddy"
        tags = ["caddy", "proxy"]
        
        check {
          name      = "caddy server health check"
          type      = "http"
           path     = "/health-check"
          port      =  "healthcheck"
          interval  = "10s"
          timeout   = "2s"
        }
      }

    }
  }

}
