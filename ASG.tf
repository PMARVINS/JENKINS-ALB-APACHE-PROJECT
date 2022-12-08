#creating autoscaling group for webserver //
resource "aws_autoscaling_group" "Webserver-autoscaling-group" {
  name                      = "Webserver-autoscaling-group"
  desired_capacity          = "1"
  max_size                  = "4"
  min_size                  = "1"
  health_check_grace_period = "300"
  health_check_type         = "ELB"
  vpc_zone_identifier       = [aws_subnet.SubnetA.id, aws_subnet.SubnetB.id]

  launch_template {
    id      = aws_launch_template.webserver-launch-template.id
    version = "$Latest"
  }
}

#creating autoscaling group for App servers //
resource "aws_autoscaling_group" "Appserver-autoscaling-group" {
  name                      = "Appserver-autoscaling-group"
  desired_capacity          = "1"
  max_size                  = "4"
  min_size                  = "1"
  health_check_grace_period = "300"
  health_check_type         = "ELB"
  vpc_zone_identifier       = [aws_subnet.SubnetC.id, aws_subnet.SubnetD.id]

  launch_template {
    id      = aws_launch_template.application-tier-launch-template.id
    version = "$Latest"
  }
}