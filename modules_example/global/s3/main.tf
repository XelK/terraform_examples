provider "aws" {
  region = "us-east-2"
}

terraform {
  backend "s3" {
    bucket = "469169qa780679234-terraform-test"
    key    = "workspaces/global/terraform.tfstate"
    region = "us-east-2"

    dynamodb_table = "terraform-test-locks"
    encrypt        = true
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name
  region = "us-east-2"

  #	# prevent accidental deletion of this s3 bucket
  #	lifecycle {
  #		prevent_destroy = true
  #	}
  # enable versioning
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  force_destroy = true
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}