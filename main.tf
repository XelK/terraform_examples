provider "aws"{
	region = "us-east-2"
}

variable "port"{
	description = "default port"
	type = number 
	default = 8080
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_lb" "example"{
	name = "terraform-asg-examle"
	load_balancer_type = "application"
	subnets = data.aws_subnet_ids.default.ids
}

resource "aws_launch_configuration" "example"{
	image_id = "ami-0c55b159cbfafe1f0"
	instance_type = "t2.micro"
	security_groups = [aws_security_group.instance.id]

	user_data = <<-EOF
		#!/bin/bash
		echo "Hello, World!" > index.html
		nohup busybox httpd -f -p "${ var.port }" &
		EOF

	# Required when using a launch configuration with an auto scaling group.
  	# https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  	lifecycle {
  	  create_before_destroy = true
  	}
}

resource "aws_autoscaling_group" "example" {
	launch_configuration = aws_launch_configuration.example.name
	vpc_zone_identifier = data.aws_subnet_ids.default.ids
	min_size = 1
	max_size = 2
	tag {
		key = "Name"		
		value = "terraform-asg"
		propagate_at_launch = true
	}
}

#resource "aws_instance" "example"{
#	ami = "ami-0c55b159cbfafe1f0"
#	instance_type = "t2.micro"
#	vpc_security_group_ids = [aws_security_group.instance.id]
#
#	user_data = <<-EOF
#		#!/bin/bash
#		echo "Hello, World!" > index.html
#		nohup busybox httpd -f -p "${ var.port }" &
#		EOF
#
#	tags = {
#		Name = "terraform-example"
#	}
#
#}

resource "aws_security_group" "instance"{
	name = "terraform-example"
	
	ingress {
		from_port = "${ var.port }"
		to_port = "${ var.port }"
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

#output "public_ip"{
#	description="The public IP address of the web server"
#	value = aws_instance.example.public_ip
#}
