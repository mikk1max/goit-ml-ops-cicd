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