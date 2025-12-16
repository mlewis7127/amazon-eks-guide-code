################################################################################
# EKS Module with Auto Mode (official syntax)
################################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.10.1"

  name               = var.cluster_name
  kubernetes_version = "1.34"

  # Optional: Public access to API server
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  # EKS Auto Mode configuration
  compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  # Connect to VPC module outputs
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  tags = {
    Environment = "test"
    Terraform   = "true"
  }
}