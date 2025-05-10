# IAM Role for EC2 to use AWS Systems Manager
resource "aws_iam_role" "web_server_role" {
  name = "WebServerInstanceProfile"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    Name = "WebServerInstanceProfile"
  }
}

# Attach the AmazonSSMManagedInstanceCore policy to the role
resource "aws_iam_role_policy_attachment" "ssm_policy_attach" {
  role       = aws_iam_role.web_server_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Create an Instance Profile for EC2 to use the IAM Role
resource "aws_iam_instance_profile" "web_server_instance_profile" {
  name = "WebServerInstanceProfile"
  role = aws_iam_role.web_server_role.name
}
