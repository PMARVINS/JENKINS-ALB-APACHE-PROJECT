# Define CIDR block for VPC
variable "vpc-cidr" {
    default        = "10.0.0.0/16"
    description    = "CIDR block for VPC"
    type           = string
  
}

# Define Public subnet 1 CIDR block - Web Tier
variable "SubnetA-cidr" {
    default        = "10.0.1.0/24"
    description    = "Define Public subnet 1 CIDR block"
    type           = string
  
}

# Define Public subnet 2 CIDR block - Web Tier
variable "SubnetB-cidr" {
    default        = "10.0.2.0/24"
    description    = "Define Public subnet 2 CIDR block"
    type           = string
  
}

# Define Private subnet 1 CIDR block - Application Tier
variable "SubnetC-cidr" {
    default        = "10.0.3.0/24"
    description    = "Define Private subnet 1 CIDR block"
    type           = string
  
}

# Define Private subnet 2 CIDR block - Application Tier
variable "SubnetD-cidr" {
    default        = "10.0.4.0/24"
    description    = "Define Private subnet 2 CIDR block"
    type           = string
  
}

# Define Private Data subnet 1 CIDR block - Database Tier
variable "SubnetE-cidr" {
    default        = "10.0.5.0/24"
    description    = "Define Private data subnet 1 CIDR block"
    type           = string
  
}

# Define Private Data subnet 2 CIDR block - Database Tier
variable "SubnetF-cidr" {
    default        = "10.0.6.0/24"
    description    = "Define Private data subnet 2 CIDR block"
    type           = string
  
}