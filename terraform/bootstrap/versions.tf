terraform {
  required_version = ">= 1.10" # needed for native S3 backend locking (use_lockfile) in terraform/fase1

  required_providers {
    aws = {
      source = "hashicorp/aws"
      # >= 6.22 is required for S3 tag-on-create (tags sent inside
      # CreateBucketConfiguration) — needed to satisfy the org's tagging SCP,
      # since older provider versions create the bucket first and tag it in
      # a separate call, which the SCP's aws:RequestTag condition can't see.
      version = ">= 6.22, < 7.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  # The Organization's SCP denies EC2/RDS/S3 creation calls that don't
  # request these tags, so every resource this provider creates needs them.
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
    }
  }
}
