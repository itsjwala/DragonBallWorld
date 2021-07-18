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
        host_network = "tailscale"
      }
      
    }

    task "mysql_db" {
      driver = "docker"
      config {
        image = "docker.io/bitnami/mysql:8.0"

        // bind mount mysql directory for persistence
        mount {
          type     = "bind"
          source   = "local"
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
      attempts = 2
      interval = "2m"
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

    task "wordpress" {
      driver = "docker"

      config {
        image = "docker.io/bitnami/wordpress:5"

        // bind mount mysql directory for persistence
        mount {
          type     = "bind"
          source   = "local"
          target   = "/bitnami/wordpress"
        }
        ports = ["http","https"]
      }

      env {
        ALLOW_EMPTY_PASSWORD    = "yes"
        BITNAMI_DEBUG = "true"
        WORDPRESS_DATABASE_USER = "${fmd_db_user}"
        WORDPRESS_DATABASE_NAME = "${fmd_db_name}"
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
