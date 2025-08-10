resource "aws_launch_template" "web_lt" {
  name_prefix   = "aws101-web-"
  image_id      = data.aws_ssm_parameter.latest_amazon_linux_2023.value
  instance_type = "t3.micro" # or "t2.micro" if you prefer

  iam_instance_profile {
    name = aws_iam_instance_profile.web_server_instance_profile.name
  }

  network_interfaces {
    security_groups             = [aws_security_group.web_server_sg.id]
    associate_public_ip_address = false
  }

  credit_specification {
    cpu_credits = "standard"
  }

  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y || dnf update -y
systemctl enable amazon-ssm-agent || true
systemctl start amazon-ssm-agent || true
dnf install -y httpd wget php-json php unzip
chkconfig httpd on || true
systemctl start httpd
systemctl enable httpd
wget https://docs.aws.amazon.com/aws-sdk-php/v3/download/aws.zip
unzip -o aws.zip -d /var/www/html/sdk
rm -f aws.zip
cd /var/www/html
[ -f index.html ] && rm -f index.html
wget -O index.php https://ws-assets-prod-iad-r-iad-ed304a55c2ca1aee.s3.us-east-1.amazonaws.com/2aa53d6e-6814-4705-ba90-04dfa93fc4a3/index.php
EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "aws101-web"
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name = "aws101-web"
    }
  }
}

resource "aws_autoscaling_group" "web_asg" {
  name                      = "aws101-web-asg"
  min_size                  = 1
  desired_capacity          = 1
  max_size                  = 3
  vpc_zone_identifier       = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id]

  health_check_type         = "ELB"
  health_check_grace_period = 300
  target_group_arns         = [aws_lb_target_group.web_server_tg.arn]

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "aws101-web"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "cpu_target" {
  name                   = "cpu-40pct-target"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name

  # Target tracking on ASG average CPU
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value     = 40
    disable_scale_in = false
  }

  # Optional: how long to consider new instances "warming up"
  estimated_instance_warmup = 300
}

