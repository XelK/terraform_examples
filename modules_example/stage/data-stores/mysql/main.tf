provider "aws" {
  region = "us-east-2"
}

terraform {
  backend "s3" {
    bucket = "469169qa780679234-terraform-test"
    key    = "workspaces/stage/data-store/mysql/terraform.tfstate"
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
  #password            = data.aws_secrestmanager_secret_version.db_password.secret_string
  password            = var.db_password
}

# data "aws_secretsmanager_secret_version" "db_password" {
#   secret_id = "mysql-master-password-stage"
# }
