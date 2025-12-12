# EKS Auto Mode - Terraform Modules Approach

This approach uses community Terraform modules to create EKS Auto Mode infrastructure with less code and built-in best practices.

## What Gets Created

The modules automatically create:
- **VPC Module**: VPC, subnets, NAT Gateway, Internet Gateway, route tables
- **EKS Module**: EKS cluster, IAM roles, security groups, Auto Mode configuration

## Modules Used

- **VPC**: `terraform-aws-modules/vpc/aws` (v5.13.0)
- **EKS**: `terraform-aws-modules/eks/aws` (v20.24.0)

## Configuration

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
```

Variables:
- `aws_region` - AWS region (default: eu-west-2)
- `cluster_name` - EKS cluster name (default: test-eks-cluster-modules)
- `vpc_cidr` - VPC CIDR block (default: 10.1.0.0/16)

## Deploy

```bash
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

## Hidden Resources

The modules create these resources internally:
- **Cluster IAM Role**: With AmazonEKSClusterPolicy + Auto Mode policies
- **Node IAM Role**: With AmazonEKSWorkerNodeMinimalPolicy + ECR policies
- **Security Groups**: For cluster and node communication
- **Route Tables**: Public and private routing

Access via outputs:
```hcl
module.eks.cluster_iam_role_arn
module.eks.eks_managed_node_groups_iam_role_arn
```

## Pros

- **Less Code**: ~100 lines vs ~280 lines
- **Best Practices**: Community-tested configurations
- **Maintenance**: Module updates handle AWS changes
- **Quick Setup**: Faster to deploy

## Cons

- **Less Control**: Harder to customize specific details
- **Hidden Complexity**: Resources created inside modules
- **Dependencies**: Reliant on module maintainers
- **Learning**: Less visibility into what's actually created