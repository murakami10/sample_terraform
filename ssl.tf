
#resource "aws_acm_certificate" "sample" {
#  domain_name = "${local.domain}"
#  subject_alternative_names = ["*.${local.domain}"]
#
#  validation_method = "DNS"
#  lifecycle {
#    create_before_destroy = true
#  }
#}
#
#resource "aws_route53_record" "cert_validation" {
#
#
#  for_each = {
#  for dvo in aws_acm_certificate.sample.domain_validation_options : dvo.domain_name => {
#    name   = dvo.resource_record_name
#    record = dvo.resource_record_value
#    type   = dvo.resource_record_type
#  }
#  }
#  name            = each.value.name
#  records         = [each.value.record]
#  ttl             = 60
#  type            = each.value.type
#  zone_id         = data.aws_route53_zone.sample.id
#  allow_overwrite = true
#}