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
