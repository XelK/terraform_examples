provider "aws" {
region = "us-east-2"
}

terraform {
  backend "s3" {
    bucket = "469169qa780679234-terraform-test"
    key    = "workspaces/stage/terraform.tfstate"
    region = "us-east-2"

    dynamodb_table = "terraform-test-locks"
    encrypt        = true
  }
}

resource "aws_db_instance" "tf_example_db" {
  identifier_prefix   = "terraform-db-example"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  skip_final_snapshot = true
  name                = var.db_name
  username            = "admin"
  password            = var.db_password
}
