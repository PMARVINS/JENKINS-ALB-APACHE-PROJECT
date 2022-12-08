#Configure security groups
#Internet facing load balancer secgroup
resource "aws_security_group" "web-elb-sg" {
  name        = "web-elb-sec"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow HTTP "
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-elb-sec"
  }
}


#Web tier security group (Public EC2 Instances)
resource "aws_security_group" "webtier-sg" {
  name        = "webtier-sg"
  description = "Allow HTTP, SSH and Web-Elb-sec inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow HTTP "
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.web-elb-sg.id]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "webtier-sg"
  }
}


#Internal Load Balancer security group 
resource "aws_security_group" "internal-elb-sg" {
  name        = "Internal-elb-sg"
  description = "Allow inbound traffic from webtier-sg"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "webtier-sg from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.webtier-sg.id]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      =["0.0.0.0/0"]
    security_groups  = [aws_security_group.webtier-sg.id]
  }

  tags = {
    Name = "Internal-elb-sg"
  }
}


#App Tier security group 
resource "aws_security_group" "apptier-sg" {
  name        = "apptier-sg"
  description = "Allow inbound traffic from Internal-elb-sg"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "Allow inbound traffic from Internal-elb-sg"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.internal-elb-sg.id]
  }
  
  ingress {
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      =["0.0.0.0/0"]
  }

  tags = {
    Name = "apptier-sg"
  }
}


#Database Security Group
resource "aws_security_group" "DB-tier-sg" {
  name        = "DB-tier-sg"
  description = "Allow inbound traffic from App tier"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "Database Port "
    from_port        = 3306 
    to_port          = 3306 
    protocol         = "tcp"
    security_groups  = [aws_security_group.apptier-sg.id]
  }


  tags = {
    Name = "Group-Sec-grp"
  }
}