# AWS EKS & VPC Infrastructure (Lesson 5-6)

Цей проєкт розгортає VPC та EKS кластер в AWS за допомогою офіційних Terraform модулів.
Інфраструктура розроблена для майбутніх ML-сервісів і включає дві Node Groups (CPU та GPU workloads).

## Структура

- `vpc/` - модуль створення мережі (NAT, публічні/приватні сабнети).
- `eks/` - модуль створення кластера Kubernetes.
- `main.tf` (корінь) - викликає обидва модулі та передає залежності.

## Інструкція з розгортання

1. Авторизуйтесь в AWS (`aws configure`).
2. Ініціалізуйте Terraform:
   `terraform init`
3. Перегляньте план ресурсів:
   `terraform plan`
4. Застосуйте зміни (створення займає ~15-20 хвилин):
   `terraform apply -auto-approve`
5. Підключіться до кластера:
   `aws eks --region eu-central-1 update-kubeconfig --name ml-production-cluster`
6. Перевірте ноди:
   `kubectl get nodes`

## ⚠️ Знищення ресурсів

Щоб уникнути зайвих витрат, обов'язково видаліть ресурси після тестування:
`terraform destroy -auto-approve`
