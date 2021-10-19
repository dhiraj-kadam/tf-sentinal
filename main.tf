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


resource "aws_kms_key" "a" {
  description             = "KMS key 1"
  deletion_window_in_days = 10
}
resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket_name}"
  
  
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.a.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    owner = "sentinel"
  }
}

resource "aws_s3_bucket_policy" "b" {
  bucket = aws_s3_bucket.bucket.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        Sid       = "enforce-https"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:Put*"
        Resource = "arn:aws:s3:::${aws_s3_bucket.bucket.id}/*"
        Condition = {
          StringNotEquals = {
            "s3:x-amz-server-side-encryption-aws-kms-key-id" = "${aws_kms_key.a.arn}"
          }
        }
      },
    ]
  })
}
