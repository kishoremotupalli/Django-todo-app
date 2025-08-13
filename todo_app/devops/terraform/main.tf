# VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.8"
  name    = "${var.name}-vpc"
  cidr    = "10.0.0.0/16"

  azs              = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets  = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
  public_subnets   = ["10.0.101.0/24","10.0.102.0/24","10.0.103.0/24"]
  enable_nat_gateway = true
  single_nat_gateway = true
}

# EKS
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.8"

  cluster_name    = "${var.name}-eks"
  cluster_version = "1.29"
  subnet_ids      = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  eks_managed_node_groups = {
    default = {
      desired_size  = 2
      min_size      = 1
      max_size      = 3
      instance_types = ["t3.medium"]
    }
  }
}

# ECR
resource "aws_ecr_repository" "app" {
  name = "${var.name}-repo"
  image_scanning_configuration { scan_on_push = true }
  force_delete = true
}