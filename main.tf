provider "aws"{
	region = "us-east-2"
}

variable "port"{
	description = "default port"
	type = number 
	default = 8080
}

resource "aws_instance" "example"{
	ami = "ami-0c55b159cbfafe1f0"
	instance_type = "t2.micro"
	vpc_security_group_ids = [aws_security_group.instance.id]

	user_data = <<-EOF
		#!/bin/bash
		echo "Hello, World!" > index.html
		nohup busybox httpd -f -p "${ var.port }" &
		EOF

	tags = {
		Name = "terraform-example"
	}

}

resource "aws_security_group" "instance"{
	name = "terraform-example"
	
	ingress {
		from_port = "${ var.port }"
		to_port = "${ var.port }"
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

output "public_ip"{
	description="The public IP address of the web server"
	value = aws_instance.example.public_ip
}
