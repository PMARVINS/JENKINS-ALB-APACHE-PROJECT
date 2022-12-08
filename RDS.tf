#creating database subnet group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = [aws_subnet.SubnetE.id, aws_subnet.SubnetF.id]

}

#create our rds database using terraform
resource "aws_db_instance" "db-instance" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0.28"
  instance_class         = "db.t3.micro"
  username               = "Admin"
  password               = "Admin1234"
  multi_az               = true
  storage_type           = "gp2"
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.id
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.DB-tier-sg.id]
  publicly_accessible    = false

  tags = {
    Name = "db-instance"
  }
}