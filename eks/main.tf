# АЛЬТЕРНАТИВА З REMOTE STATE (робити розкоментованим, якщо вимагає ментор замість передачі змінних):
# data "terraform_remote_state" "vpc" {
#   backend = "local" # або s3
#   config = {
#     path = "../vpc/terraform.tfstate"
#   }
# }

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.30"

  # Якщо використовуєте root main.tf, дані приходять зі змінних:
  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids
  
  # Дозволяємо публічний доступ до API кластера (щоб працював kubectl з вашого ПК)
  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

eks_managed_node_groups = {
    cpu_nodes = {
      instance_types = ["t3.micro"]
      min_size       = 1
      max_size       = 5
      desired_size   = 4
      labels = {
        workload = "cpu"
      }
    }
    gpu_nodes = {
      instance_types = ["t3.micro"]
      min_size       = 1
      max_size       = 1
      desired_size   = 1
      labels = {
        workload = "gpu"
      }
    }
  }
}