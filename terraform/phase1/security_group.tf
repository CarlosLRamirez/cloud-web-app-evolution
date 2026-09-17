resource "aws_security_group" "brewops_web" {
  name        = "brewops-web-sg"
  description = "BrewOps Phase 1 monolith SSH from the operators IP, app port from anywhere"
  vpc_id      = data.terraform_remote_state.landing_zone.outputs.mywebapp_dev_vpc_id

  tags = {
    Name = "brewops-web-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh_from_operator" {
  security_group_id = aws_security_group.brewops_web.id
  description       = "SSH from the operators IP only"
  cidr_ipv4         = "${var.operator_ip}/32"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "app_public" {
  security_group_id = aws_security_group.brewops_web.id
  description       = "Public access to the BrewOps app"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.app_port
  to_port           = var.app_port
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.brewops_web.id
  description       = "Allow all outbound traffic"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
