terraform {
  required_version = ">= 0.11.7"
}

variable "aws_region" {
  description = "AWS region"
  default = "us-east-1"
}

variable "bucket_name" {
   description = "Name of the bucket to create"
   default = "decay-test-s3-sentinel-bucket"
}

provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket_name}"
  
  
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "arn:aws:kms:us-east-1:753646501470:key/00c892e8-40c4-4048-a650-0f755876503d"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    owner = "sentinel"
  }
}
