provider "aws"{
	region = "us-east-2"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_security_group" "selected" {
	name = "${var.sg-alb}"
	depends_on = [ aws_security_group.alb ]
}