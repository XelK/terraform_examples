resource "aws_security_group" "alb" {
  name                   = var.sg-alb
  revoke_rules_on_delete = true
  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "security-group for alb"

  }
}

resource "aws_security_group" "instance" {
  name                   = "terraform-example-instance"
  revoke_rules_on_delete = true
  ingress {
    description     = "limit access only from load balancer"
    from_port       = var.port
    to_port         = var.port
    protocol        = "tcp"
    security_groups = [data.aws_security_group.selected.id]
  }
  egress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "security-group for instance"
  }
}
