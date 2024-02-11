resource "aws_acm_certificate" "saitejag_site" {
  domain_name       = "*.saitejag.site"
  validation_method = "DNS"

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-acm"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "saitejag_site" {
  for_each = {
    for dvo in aws_acm_certificate.saitejag_site.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.saitejag_site.zone_id
}

resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = aws_acm_certificate.saitejag_site.arn
  validation_record_fqdns = [for record in aws_route53_record.saitejag_site : record.fqdn]
}