terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.3.0"
}

provider "aws" {
  region  = "us-east-1" # Change this to your preferred region
  profile = "default"   # Optional: uses credentials from ~/.aws/credentials
}
