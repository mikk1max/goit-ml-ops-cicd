terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
  }
}

provider "aws" {
  region = "eu-central-1" # Замініть на свій регіон
}

module "vpc" {
  source = "./vpc"
  
  vpc_name = "production-vpc"
  vpc_cidr = "10.0.0.0/16"
}

module "eks" {
  source = "./eks"

  cluster_name = "ml-production-cluster"
  
  # Передача значень від VPC до EKS напряму (Best Practice для єдиного state)
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
}

# Дані для підключення Helm до EKS
data "aws_eks_cluster" "default" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}
data "aws_eks_cluster_auth" "default" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.default.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.default.token
  }
}

module "argocd" {
  source     = "./argocd"
  depends_on = [module.eks] # Важливо! Спочатку EKS, потім ArgoCD
}