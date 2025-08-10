data "aws_ssm_parameter" "latest_amazon_linux_2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# resource "aws_instance" "mywebserver" {
#   ami                    = data.aws_ssm_parameter.latest_amazon_linux_2023.value
#   instance_type          = "t2.micro"
#   subnet_id              = aws_subnet.private_subnet_a.id
#   vpc_security_group_ids = [aws_security_group.web_server_sg.id]
#   iam_instance_profile   = aws_iam_instance_profile.web_server_instance_profile.name

#   tags = {
#     Name = "mywebserver"
#   }

#   user_data = <<EOF
# #!/bin/bash
# yum update -y
# # Install Session Manager agent
# yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
# systemctl enable amazon-ssm-agent
# # Install and start the php web server
# dnf install -y httpd wget php-json php
# chkconfig httpd on
# systemctl start httpd
# systemctl enable httpd

# # Install AWS SDK for PHP
# wget https://docs.aws.amazon.com/aws-sdk-php/v3/download/aws.zip
# unzip aws.zip -d /var/www/html/sdk
# rm aws.zip

# # Install the web pages for our lab
# if [ ! -f /var/www/html/index.html ]; then
# rm index.html
# fi
# cd /var/www/html
# wget https://ws-assets-prod-iad-r-iad-ed304a55c2ca1aee.s3.us-east-1.amazonaws.com/2aa53d6e-6814-4705-ba90-04dfa93fc4a3/index.php

# # Update existing packages
# dnf update -y
# EOF
# }
