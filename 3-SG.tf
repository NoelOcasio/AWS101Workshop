resource "aws_security_group" "load_balancer_sg" {
  name        = "Load Balancer Security Group"
  description = "External Access"
  vpc_id      = aws_vpc.project_vpc.id

  # Allow HTTP access from anywhere with updated description
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP Inbound from Internet"
  }

  # Allow inbound traffic on the load balancer listener port (e.g., 8080)
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow custom listener port"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "LoadBalancerSecurityGroup"
  }
}

resource "aws_security_group" "web_server_sg" {
  name        = "Web Server Security Group"
  description = "Web Server Access"
  vpc_id      = aws_vpc.project_vpc.id

  # Inbound rule for HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [
      aws_security_group.load_balancer_sg.id
    ]
    description = "Allow HTTP Inbound from Load Balancer"
  }

  # Outbound rules (allow all by default)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "WebServerSecurityGroup"
  }
}
