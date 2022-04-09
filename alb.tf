
resource "aws_lb" "sample" {
  name               = "sample"
  internal           = false
  load_balancer_type = "application"
  idle_timeout       = 60
  security_groups    = [aws_security_group.sample_elb.id]
  subnets            = [for subnet in aws_subnet.sample_public : subnet.id]

  #  access_logs {
  #    bucket = ""
  #  }

  tags = {
    Name = "sample"
  }
}

resource "aws_lb_target_group" "sample" {
  name     = "sample"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.sample.id

  health_check {
    path = "/"
    port = 3000
  }
}

resource "aws_lb_target_group_attachment" "sample" {
  count            = length(aws_instance.sample-web-server)
  target_group_arn = aws_lb_target_group.sample.arn
  target_id        = aws_instance.sample-web-server[count.index].id
}

resource "aws_lb_listener" "sample" {
  load_balancer_arn = aws_lb.sample.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sample.arn
  }
}

#resource "aws_lb_listener" "sample" {
#  load_balancer_arn = aws_lb.sample.arn
#  port              = 443
#  protocol          = "HTTPS"
#  ssl_policy        = "ELBSecurityPolicy-2016-08"
#  certificate_arn   = aws_acm_certificate.sample.arn
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.sample.arn
#  }
#}
