output "wordpress_url" {
  value = "http://${local.minikube_ip}:${kubernetes_service.wordpress.spec.0.port.0.node_port}"
}

output "minikube_ip" {
  value = local.minikube_ip
}

locals {
  minikube_ip = trimspace(chomp(data.external.minikube_ip.result.output))
}

data "external" "minikube_ip" {
  program = ["bash", "${path.module}/minikube_ip.sh"]
}
# add new git
