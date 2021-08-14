job "adguard" {
  datacenters = ["DragonBallWorld"]
  type        = "service"

    group "adguard" {
    
    constraint {
      attribute = "$${attr.unique.hostname}"
      value     = "gohan"
    }

    network {

      port "admin-port" {
        to            = 3000
        static        = 3000
        host_network  = "tailscale"
      }

      port "dns-port-lan" {
        static = 53
        to     = 53
      }
      
      port "dns-port-tailscale" {
        static = 53
        to     = 53
        host_network = "tailscale"
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
        args = ["-c", "mkdir -p /opt/adguard/ && chown -R nobody:nogroup /opt/adguard"]
      }
      
      resources {
        cpu    = 1
        memory = 10
      }

    }

    task "adguard" {

      driver = "docker"

      config {
        image = "adguard/adguardhome"


        mount {
          type     = "bind"
          source   = "/opt/adguard/work"
          target   = "/opt/adguardhome/work"
          readonly = false
        }
        
        mount {
          type     = "bind"
          source   = "/opt/adguard/conf"
          target   = "/opt/adguardhome/conf"
          readonly = false
        }

        ports = ["admin-port", "dns-port-lan", "dns-port-tailscale"]
      }

      resources {
        cpu    = 100
        memory = 50
      }

      # template {
      #   data = <<EOF
      #   ${caddyfile_external}
      #   EOF

      #   destination = "configs/Caddyfile" # Rendered template.

      #   # Caddy doesn't support reload via signals as of now
      #   change_mode = "restart"
      # }

      service {
        name = "adguard"
        tags = ["adguard"]
        port =  "admin-port"
        
        check {
          name      = "adguard admin page"
          type      = "http"
          path      = "/"
          port      =  "admin-port"
          interval  = "10s"
          timeout   = "2s"
        }

      }

    }
  }


}
