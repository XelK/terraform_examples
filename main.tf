provider "aws"{
	region = "us-east-2"
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
	security_groups = [aws_security_group.alb.id]
}

resource "aws_security_group" "alb" {
	name = "terraform-example-alb"
	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_lb_listener" "http" {
	load_balancer_arn = aws_lb.example.arn
	#port = 80
	port = "${ var.port }"
	protocol = "HTTP"
	default_action {
		type = "fixed-response"	
		fixed_response {
			content_type = "text/plain"		
			message_body = "404: page not found"
			status_code = 404
		}
	}
}

resource "aws_lb_target_group" "asg" {
	name = "terraform-asg-example"
	port = var.port
	protocol = "HTTP"
	vpc_id = data.aws_vpc.default.id

	health_check {
		path = "/"	
		protocol = "HTTP"
		matcher = "200"
		interval = 15
		timeout = 3
		healthy_threshold = 2
		unhealthy_threshold = 2
	}
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

	target_group_arns = [aws_lb_target_group.asg.arn]
	health_check_type = "ELB"

	min_size = 1
	max_size = 2
	tag {
		key = "Name"		
		value = "terraform-asg"
		propagate_at_launch = true
	}
}

resource "aws_lb_listener_rule" "asg" {
	listener_arn = aws_lb_listener.http.arn
	priority = 100
	condition {
		field = "path-pattern"	
		values = ["*"]
	}
	action {
		type = "forward"	
		target_group_arn = aws_lb_target_group.asg.arn
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
