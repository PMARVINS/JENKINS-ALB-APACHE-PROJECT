# Configure Public subnet A - Web Tier- with default route to Internet Gateway
resource "aws_subnet" "SubnetA"{
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.SubnetA-cidr
    availability_zone = "eu-west-2a"
    map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-A"
  }
}

# Configure Public subnet b - Web Tier-  with default route to Internet Gateway
resource "aws_subnet" "SubnetB"{
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.SubnetB-cidr
    availability_zone = "eu-west-2b"
    map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-B"
  }
}

#Public Route tables
resource "aws_route_table" "publicroutetable" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Public-Route-Table"
  }
}

# Configure Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Internet-Gateway"
  }
}

# Associate IGW with public route table
resource "aws_route" "igw-route" {
  route_table_id            = aws_route_table.publicroutetable.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.igw.id
}

# Public route table assocations
resource "aws_route_table_association" "rtassociationpubA" {
  subnet_id       = aws_subnet.SubnetA.id
  route_table_id  = aws_route_table.publicroutetable.id
}

# Public route table assocations
resource "aws_route_table_association" "rtassociationpubB" {
  subnet_id      = aws_subnet.SubnetB.id
  route_table_id  = aws_route_table.publicroutetable.id
}



# Configure Private subnet C - Application Tier - with default route to Nat Gateway
resource "aws_subnet" "SubnetC"{
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.SubnetC-cidr
    availability_zone = "eu-west-2a"
    map_public_ip_on_launch = false

  tags = {
    Name = "Public-Subnet-C"
  }
}

# Configure Private subnet D -Application Tier - with default route to Nat Gateway
resource "aws_subnet" "SubnetD"{
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.SubnetD-cidr
    availability_zone = "eu-west-2b"
    map_public_ip_on_launch = false

  tags = {
    Name = "Public-Subnet-D"
  }
}

#Private Route table 1
resource "aws_route_table" "privateroutetable1" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Private-Route-table 1"
  }
}

#Private Route table 2
resource "aws_route_table" "privateroutetable2" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Private-Route-table-2"
  }
}

# Provision Elastic IP for NAT Gateway
resource "aws_eip" "eip" {
  vpc         = true
  depends_on  = [aws_internet_gateway.igw]

  tags = {
    "name" = "Natgateway-EIP-1"
  }
} 

resource "aws_eip" "eip2" {
  vpc         = true
  depends_on  = [aws_internet_gateway.igw]

  tags = {
    "name" = "Natgateway-EIP-2"
  }
} 

# Provision Nat Gateway
resource "aws_nat_gateway" "natgateway1" {
  allocation_id  = aws_eip.eip.id
  subnet_id      = aws_subnet.SubnetA.id

    tags = {
    Name = "igw-NAT"
  }
}

# Provision Nat Gateway
resource "aws_nat_gateway" "natgateway2" {
  allocation_id  = aws_eip.eip2.id
  subnet_id      = aws_subnet.SubnetB.id

    tags = {
    Name = "igw-NAT-2"
  }
}

# Associate Nat with Private route table
resource "aws_route" "NAT-route" {
  route_table_id            = aws_route_table.privateroutetable1.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_nat_gateway.natgateway1.id
}

# Associate Nat with Private route table
resource "aws_route" "NAT-route-2" {
  route_table_id            = aws_route_table.privateroutetable2.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_nat_gateway.natgateway2.id
}


# Private route table Association 
resource "aws_route_table_association" "rtassociationprivC" {
  subnet_id       = aws_subnet.SubnetC.id 
  route_table_id  = aws_route_table.privateroutetable1.id
}

# Private route table Association 
resource "aws_route_table_association" "rtassociationprivD" {
  subnet_id       = aws_subnet.SubnetD.id
  route_table_id  = aws_route_table.privateroutetable2.id
}





# Configure Private Data subnet E -Database Tier 
resource "aws_subnet" "SubnetE"{
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.SubnetE-cidr
    availability_zone = "eu-west-2a"
    map_public_ip_on_launch = false

  tags = {
    Name = "Public-Subnet-E"
  }
}


# Configure Private Data subnet F -Database Tier 
resource "aws_subnet" "SubnetF"{
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.SubnetF-cidr
    availability_zone = "eu-west-2b"
    map_public_ip_on_launch = false

  tags = {
    Name = "Public-Subnet-F"
  }
}


#Private Data Route tables
resource "aws_route_table" "dataroutetable" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Data-RouteTable"
  }
}

# Private route table Association 
resource "aws_route_table_association" "rtassociationdatA" {
  subnet_id      = aws_subnet.SubnetE.id
  route_table_id = aws_route_table.dataroutetable.id
}

# Private route table Association 
resource "aws_route_table_association" "rtassociationdatB" {
  subnet_id       = aws_subnet.SubnetF.id
  route_table_id  = aws_route_table.dataroutetable.id
}