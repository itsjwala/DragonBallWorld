job "wordpress_fmd" {
  datacenters = ["DragonBallWorld"]
  type        = "service"

  group "mysql_db" {
    constraint {
      attribute = "$${attr.unique.hostname}"
      value     = "goku"
    }

    restart {
      attempts = 2
      interval = "2m"
      delay    = "30s"
      mode     = "fail"
    }

    network {
      port "mysql-port" {
        to = 3306
        static = 33306
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
        args = ["-c", "mkdir -p /opt/fmd/db && chown 1001:1001 -R /opt/fmd/db"]
      }
      resources {
        cpu    = 1
        memory = 10
      }
    }

    task "mysql_db" {
      driver = "docker"
      config {
        image = "docker.io/bitnami/mysql:8.0"

        // bind mount mysql directory for persistence
        mount {
          type     = "bind"
          source   = "/opt/fmd/db"
          target   = "/bitnami/mysql"
        }
        ports = ["mysql-port"]
      }

      env {
        ALLOW_EMPTY_PASSWORD = "yes"
        MYSQL_USER = "${fmd_db_user}"
        MYSQL_DATABASE = "${fmd_db_name}"
      }

      resources {
        cpu    = 200
        memory = 500
      }

      service {
        name = "fmd-db"
        tags = [ "fmd" , "wordpress" ]

        port =  "mysql-port"

        check {
          name = "fmd db mysql port check"
          type     = "tcp"
          port =  "mysql-port"
          interval = "10s"
          timeout  = "2s"
        }

      }

    }
  
  }

  group "wordpress" {
    constraint {
      attribute = "$${attr.unique.hostname}"
      value     = "goku"
    }

    restart {
      attempts = 5
      interval = "5m"
      delay    = "30s"
      mode     = "fail"
    }

    network {
      port "http" {
        to = 8080
      }      

      port "https" {
        to = 8443
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
        args = ["-c", "mkdir -p /opt/fmd/wordpress && chown 1001:1001 -R /opt/fmd/wordpress"]
      }
      resources {
        cpu    = 1
        memory = 10
      }
    }

    task "wordpress" {
      driver = "docker"

      config {
        image = "ghcr.io/itsjwala/wordpress:fmd"

        // bind mount mysql directory for persistence
        mount {
          type     = "bind"
          source   = "/opt/fmd/wordpress"
          target   = "/bitnami/wordpress"
        }
        ports = ["http","https"]
      }

      env {
        ALLOW_EMPTY_PASSWORD    = "yes"
        BITNAMI_DEBUG = "true"
        WORDPRESS_DATABASE_USER = "${fmd_db_user}"
        WORDPRESS_DATABASE_NAME = "${fmd_db_name}"
        WORDPRESS_USERNAME      = "${fmd_wordpress_user}"
        WORDPRESS_PASSWORD      = "${fmd_wordpress_password}"
        WORDPRESS_EMAIL         = "${fmd_wordpress_email}"
      }
      
      template {
          data = <<EOH
        {{- with service "fmd-db" }}
          {{- with index . 0 }}
            WORDPRESS_DATABASE_HOST="{{.Address}}"
            WORDPRESS_DATABASE_PORT_NUMBER="{{.Port}}"
          {{- end }}
        {{ end }}
        EOH

        destination = "configs/file.env"
        env         = true
        change_mode = "restart"
      }

      resources {
        cpu    = 200
        memory = 300
      }

      service {
        name = "fmd-wordpress"
        tags = [ "fmd" , "wordpress" ]

        port =  "http"

        check {
          name = "fmd wordpress http port check"
          type     = "tcp"
          port =  "http"
          interval = "10s"
          timeout  = "2s"
        }
      }

    }
  
  }


}
