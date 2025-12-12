# Amazon EKS Setup

This section runs through the terraform configuration for deploying the Amazon EKS cluster using Auto Mode.

The choice was made to use the community Terraform modules to create the VPC and EKS cluster, as this requires less code and uses built-in best practices. In this section we will run through exactly what gets created.

## Terraform Modules
The following community Terraform modules are used:

* **VPC Module `terraform-aws-modules/vpc/aws` (v6.5.1)** - this creates the VPC, subnets, NAT Gateway, Elastic IP, Internet Gateway and route tables
* **EKS Module `terraform-aws-modules/eks/aws` (v21.10.1)** - this creates the EKS cluster, roles and Auto Mode configuration

## Amazon EKS creation
The Amazon EKS cluster is created using the EKS module.

```terraform
# EKS Module with Auto Mode (official syntax)
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
    node_pools = ["general-purpose", "system"]
  }

  # Connect to VPC module outputs
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  tags = {
    Environment = "test"
    Terraform   = "true"
  }
}
```



The modules create these resources internally:
- **Cluster IAM Role**: With AmazonEKSClusterPolicy + Auto Mode policies
- **Node IAM Role**: With AmazonEKSWorkerNodeMinimalPolicy + ECR policies
- **Security Groups**: For cluster and node communication
- **Route Tables**: Public and private routing

Access via outputs:
```hcl
module.eks.cluster_iam_role_arn
module.eks.eks_managed_node_groups_iam_role_arn