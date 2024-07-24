## add new git
provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "wp_namespace" {
  metadata {
    name = "wp-namespace"
  }
}

resource "kubernetes_deployment" "wordpress" {
  metadata {
    name = "wordpress"
    namespace = kubernetes_namespace.wp_namespace.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "wordpress"
      }
    }

    template {
      metadata {
        labels = {
          app = "wordpress"
        }
      }

      spec {
        container {
          image = "wordpress:latest"
          name  = "wordpress"

          port {
            container_port = 80
          }

          env {
            name  = "WORDPRESS_DB_HOST"
            value = "mysql-service:3306"
          }

          env {
            name  = "WORDPRESS_DB_NAME"
            value = "wordpress"
          }

          env {
            name  = "WORDPRESS_DB_USER"
            value = "root"
          }

          env {
            name  = "WORDPRESS_DB_PASSWORD"
            value = "password"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "wordpress" {
  metadata {
    name = "wordpress"
    namespace = kubernetes_namespace.wp_namespace.metadata[0].name
  }

  spec {
    selector = {
      app = "wordpress"
    }

    port {
      port        = 80
      target_port = 80
      node_port   = 30080  # You can specify a fixed node port or use a variable
    }

    type = "NodePort"
  }
}

resource "kubernetes_deployment" "mysql" {
  metadata {
    name = "mysql"
    namespace = kubernetes_namespace.wp_namespace.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mysql"
      }
    }

    template {
      metadata {
        labels = {
          app = "mysql"
        }
      }

      spec {
        container {
          image = "mysql:5.7"
          name  = "mysql"

          port {
            container_port = 3306
          }

          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = "password"
          }

          env {
            name  = "MYSQL_DATABASE"
            value = "wordpress"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "mysql" {
  metadata {
    name = "mysql-service"
    namespace = kubernetes_namespace.wp_namespace.metadata[0].name
  }

  spec {
    selector = {
      app = "mysql"
    }

    port {
      port        = 3306
      target_port = 3306
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "wordpress" {
  metadata {
    name = "wordpress-hpa"
    namespace = kubernetes_namespace.wp_namespace.metadata[0].name
  }

  spec {
    max_replicas = 5
    min_replicas = 1

    scale_target_ref {
      kind       = "Deployment"
      name       = kubernetes_deployment.wordpress.metadata[0].name
      api_version = "apps/v1"
    }

    target_cpu_utilization_percentage = 50
  }
}
# add new git
