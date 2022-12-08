
#creating internet facing ALB for Webservers
resource "aws_lb" "alb-public" {
  name               = "alb-public"
  internal           = false
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web-elb-sg.id]
  subnets            = [aws_subnet.SubnetA.id, aws_subnet.SubnetB.id]

  enable_deletion_protection = false

  tags = {
    Name = "alb-public"
  }
}

 
#creating listener for public/frontend/external

resource "aws_lb_listener" "web-alb-listener" {
  load_balancer_arn = aws_lb.alb-public.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webtargetgroup.arn
  }
}

#target group front end/external/public

resource "aws_lb_target_group" "webtargetgroup" {
  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    port                = 80
    timeout             = 6
    healthy_threshold   = 4
    unhealthy_threshold = 2
    matcher             = 200
  }
  name        = "InfrastructureHealth"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
}

#attach target group to alb (frontend)

resource "aws_autoscaling_attachment" "asg-frontend_attachment" {
  autoscaling_group_name = aws_autoscaling_group.Webserver-autoscaling-group.id
  lb_target_group_arn   = aws_lb_target_group.webtargetgroup.arn
}



#creating internal ALB for App servers
resource "aws_lb" "alb_internal" {
  name               = "alb-internal"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.internal-elb-sg.id]
  subnets            = [aws_subnet.SubnetC.id, aws_subnet.SubnetD.id]

  enable_deletion_protection = false

  tags = {
    Name = "alb_internal"
  }
}
#creating listener (internal)

resource "aws_lb_listener" "internal-alb-listener" {
  load_balancer_arn = aws_lb.alb_internal.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internal-target-group.arn
  }
}
#create internal target group
resource "aws_lb_target_group" "internal-target-group" {
  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    port                = 80
    timeout             = 6
    healthy_threshold   = 4
    unhealthy_threshold = 2
    matcher             = "200"
  }

  name        = "internal-target-group"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
}


#attach target group to alb (internal)

resource "aws_autoscaling_attachment" "asg-internal_attachment" {
  autoscaling_group_name = aws_autoscaling_group.Appserver-autoscaling-group.id
  lb_target_group_arn   = aws_lb_target_group.internal-target-group.arn
}