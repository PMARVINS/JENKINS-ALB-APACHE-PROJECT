# Configure the AWS Provider - eu-west-2
provider "aws" {
  region  = "eu-west-2"
}

# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc-cidr
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true
  

  tags = {
    Name = "main"
  }
}