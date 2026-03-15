output "cluster_name" {
  description = "Назва кластера"
  value       = module.eks.cluster_name
}

output "configure_kubectl" {
  description = "Команда для підключення kubectl"
  value       = "aws eks update-kubeconfig --region eu-central-1 --name ${module.eks.cluster_name}"
}