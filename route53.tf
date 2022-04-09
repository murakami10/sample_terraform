
locals {
  domain = "example.com"
}

# NSの反映に時間がかかるのでhost zoneはつくらない
#resource "aws_route53_zone" "sample" {
#  name = local.domain
#}

data "aws_route53_zone" "sample"{
  name = local.domain
}

resource "aws_route53_record" "sample_bastion" {
  name    = "bastion.${local.domain}"
  type    = "A"
  zone_id = data.aws_route53_zone.sample.zone_id
  records = [aws_eip.sample_bastion.public_ip]
  ttl     = 300
}

resource "aws_route53_record" "sample_elb" {
  name    = "www.${local.domain}"
  type    = "A"
  zone_id = data.aws_route53_zone.sample.zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_lb.sample.dns_name
    zone_id                = aws_lb.sample.zone_id
  }
}

resource "aws_route53_zone" "sample_private" {
  name = "home"

  vpc {
    vpc_id = aws_vpc.sample.id
  }
}

resource "aws_route53_record" "sample_private_bastion" {
  name    = "bastion.home"
  type    = "A"
  zone_id = aws_route53_zone.sample_private.zone_id
  records = [aws_instance.sample-bastion.private_ip]
  ttl     = 300
}

resource "aws_route53_record" "sample_private_webserver" {
  count   = length(aws_instance.sample-web-server)
  name    = "web${count.index + 1}.home"
  type    = "A"
  zone_id = aws_route53_zone.sample_private.zone_id
  records = [aws_instance.sample-web-server[count.index].private_ip]
  ttl     = 300
}

resource "aws_route53_record" "sample_private_rds" {
  count   = length(aws_rds_cluster_instance.sample)
  name    = "rds${count.index}.home"
  type    = "CNAME"
  zone_id = aws_route53_zone.sample_private.zone_id
  records = [aws_rds_cluster_instance.sample[count.index].endpoint]
  ttl     = 300
}