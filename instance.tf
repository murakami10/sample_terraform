
data "aws_ami" "sample" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20220316.0-x86_64-gp2"]
  }
}

resource "aws_instance" "sample-bastion" {
    ami           = data.aws_ami.sample.id
    instance_type = "t2.micro"
    key_name      = aws_key_pair.sample.key_name

    subnet_id              = aws_subnet.sample_public[0].id
    vpc_security_group_ids = [aws_security_group.sample_bastion.id]

    tags = {
        Name = "sample-bastion"
    }
}

resource "aws_eip" "sample" {
    instance = aws_instance.sample-bastion.id
    vpc      = true
}

resource "aws_key_pair" "sample" {
  key_name   = "sample-temp-key"
  public_key = file(".key/terraform-sample.pub")
  tags = {
    Name = "sample"
  }
}

