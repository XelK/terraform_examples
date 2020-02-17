provider "aws" {
  region = "us-east-2"
}

terraform {
  backend "s3" {
    bucket = "469169qa780679234-terraform-test"
    key    = "workspaces/stage/services/webserver-cluster/terraform.tfstate"
    region = "us-east-2"

    dynamodb_table = "terraform-test-locks"
    encrypt        = true
  }
}

data "terraform_remote_state" "db" {
  backend = "s3"
  config = {
    bucket = "469169qa780679234-terraform-test"
    key = "workspaces/stage/data-store/mysql/terraform.tfstate"
    region = "us-east-2"
  }
}