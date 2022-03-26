
resource "aws_security_group" "sample_bastion" {
  name        = "sample-bastion"
  description = "for bastion server"
  vpc_id      = aws_vpc.sample.id

  tags = {
    Name = "sample-bastion"
  }
}

resource "aws_security_group_rule" "sample_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.sample_bastion.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sample_bastion_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.sample_bastion.id
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group" "sample_elb" {
  name        = "sample-elb"
  description = "for bastion server"
  vpc_id      = aws_vpc.sample.id
  tags = {
    Name = "sample-elb"
  }
}

resource "aws_security_group_rule" "sample_elb_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.sample_elb.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sample_elb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.sample_elb.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "sample_private" {
  name        = "sample-private"
  description = "for private subnet server"
  vpc_id      = aws_vpc.sample.id
  tags = {
    Name = "sample-private"
  }
}

resource "aws_security_group_rule" "sample_private_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.sample_private.id
  cidr_blocks       = ["0.0.0.0/0"]
}

