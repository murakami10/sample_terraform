
data "aws_ami" "sample-web-server" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20220316.0-x86_64-gp2"]
  }
}

resource "aws_iam_instance_profile" "sample" {
  name = "sample-profile"
  role = aws_iam_role.sample-ec2-s3.name
}

resource "aws_instance" "sample-web-server" {
  count                  = length(local.availability_zone_ids)
  ami                    = data.aws_ami.sample.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.sample.key_name
  subnet_id              = aws_subnet.sample_private[count.index].id
  vpc_security_group_ids = [aws_security_group.sample_private.id]
  iam_instance_profile   = aws_iam_instance_profile.sample.name

  user_data = <<EOF
    #!/bin/bash
    touch index.html
    echo '<html><body>Hello world${local.availability_zone_ids[count.index]}</body></html>' >> index.html
    python -m SimpleHTTPServer 3000
EOF

  tags = {
    Name = "sample-web-${local.availability_zone_ids[count.index]}"
  }
}
