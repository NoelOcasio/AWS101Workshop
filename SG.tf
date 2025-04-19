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

  # Allow HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS traffic from all sources"
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
