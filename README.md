# wordpress-AS-K8-terraform
Terraform project for Wordpress with autoscaler in Kubernetes
This Project was created based on Ubuntu 22 with Docker installed. How to install docker: https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository

Prerequisites
1 - Install Minikube:
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

2 - Install Kubectl:
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

3 - Install Terraform:
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install terraform

4 - Start Minikube:
minikube start --driver=docker

5 - Set permission of the bash script
sudo chmod +x minikube_ip.sh

5 - Terraform inicialization:
Inside the project directory run:
terraform init
terraform plan
terraform apply
