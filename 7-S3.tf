# Create an S3 Bucket
resource "aws_s3_bucket" "aws101projectnoel" {
  bucket = "aws101projectnoel"  # Globally unique name required

  tags = {
    Name = "aws101projectnoel"
  }
}

# Enable Public Access Block (recommended for security)
resource "aws_s3_bucket_public_access_block" "aws101projectnoel_block" {
  bucket = aws_s3_bucket.aws101projectnoel.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}

# IAM Policy to Allow EC2 Instance Read Access to S3
resource "aws_iam_policy" "s3_readonly_policy" {
  name        = "S3ReadOnlyPolicy"
  description = "Allows EC2 instance to read objects from aws101projectnoel S3 bucket"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::aws101projectnoel",
        "arn:aws:s3:::aws101projectnoel/*"
      ]
    }
  ]
}
EOF
}

# Attach the S3 Read Policy to the Web Server IAM Role
resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.web_server_role.name
  policy_arn = aws_iam_policy.s3_readonly_policy.arn
}
