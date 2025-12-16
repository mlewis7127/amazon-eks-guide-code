################################################################################
# Main
################################################################################

provider "aws" {
  region = var.aws_region
}

# Get availability zones
data "aws_availability_zones" "available" {
  state = "available"
}


