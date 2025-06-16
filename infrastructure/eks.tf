module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = "${var.prefix}-${var.environment}-cluster"
  cluster_version = "1.31"

  bootstrap_self_managed_addons = false

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  vpc_id     = module.eks_network.vpc_id
  subnet_ids = module.eks_network.private_subnets

  eks_managed_node_group_defaults = {
    instance_type = ["t3.medium", "t3.micro"]
  }

  eks_managed_node_groups = {
    example = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 3
      desired_size = 1

    }
  }

  tags = {
    Environment = var.environment
    Terraform   = true
    repo        = "DevOpsDojo"
  }



}