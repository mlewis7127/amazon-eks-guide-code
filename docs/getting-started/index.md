# Getting Started

## Overview
This repository provides a simple introduction to Amazon EKS. The intention is to add code samples and demos to help explain the core features.


## AWS Architecture
The

![architecture diagram](../static/amazon-eks-auto-mode.png)



### Prerequisites
- AWS CLI configured with credentials
- Terraform installed
- kubectl installed

### Deploy Infrastructure

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```









#    node_pools    = ["general-purpose", "system"]




### Configure kubectl

```bash
# Use the output from terraform apply, or replace with your values
aws eks update-kubeconfig --name <cluster-name> --region <aws-region>
```

### Clean Up

```bash
terraform plan -destroy -out=destroy-plan
terraform apply destroy-plan
```
