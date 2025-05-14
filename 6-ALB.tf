# Create the Application Load Balancer (ALB)
resource "aws_lb" "web_server_alb" {
  name               = "WebServerLoadBalancer"
  internal           = false # Internet-facing
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_sg.id]
  subnets            = [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id
  ]

  enable_deletion_protection = false

  tags = {
    Name = "WebServerLoadBalancer"
  }
}

# Create a Target Group for the Web Server
resource "aws_lb_target_group" "web_server_tg" {
  name        = "WebServerTargetGroup"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.project_vpc.id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "WebServerTargetGroup"
  }
}

# Attach the Web Server Instance to the Target Group
resource "aws_lb_target_group_attachment" "web_server_attachment" {
  target_group_arn = aws_lb_target_group.web_server_tg.arn
  target_id        = aws_instance.mywebserver.id
  port             = 80
}

# Create the ALB Listener for HTTP traffic (Port 80)
resource "aws_lb_listener" "web_server_listener" {
  load_balancer_arn = aws_lb.web_server_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_server_tg.arn
  }
}
