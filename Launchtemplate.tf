
# Creating launch template for Frontend
resource "aws_launch_template" "webserver-launch-template" {
  name_prefix            = "Web-server"
  image_id               = "ami-04706e771f950937f"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webtier-sg.id]
  user_data              = filebase64("${"install_apache.sh"}")
  key_name               = "Project"

}

# Creating launch template for Application Tier
resource "aws_launch_template" "application-tier-launch-template" {
  name_prefix            = "apptier-server"
  image_id               = "ami-04706e771f950937f"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.apptier-sg.id]
  key_name               = "Project"
}