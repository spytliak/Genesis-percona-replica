#-----------------------------------------------------------------------
# Module
#-----------------------------------------------------------------------
# AWS VPC
#-----------------------------------------------------------------------
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.14.0"
  name    = var.project
  cidr    = var.vpc_cidr

  azs = local.azs

  public_subnets = var.public_subnet_cidrs
  public_subnet_tags = {
    Name = "Public-subnet-${var.project}-${var.env}"
  }

  private_subnets = var.privet_subnet_cidrs
  private_subnet_tags = {
    Name = "Private-subnet-${var.project}-${var.env}"
  }

  enable_dns_support   = var.enabled_dns_support
  enable_dns_hostnames = var.enabled_dns_hostnames

  tags = merge(
    var.common_tags,
    {
      Name = "VPC_${var.project}-${var.env}"
    }
  )
}