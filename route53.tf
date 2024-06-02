# 퍼블릭 DNS 존 정보 조회
data "aws_route53_zone" "zone" {
  name         = "mkcloud.site"
  private_zone = false
}

# ACM 인증서 생성
provider "aws" {
  alias  = "ap_northeast_2"
  region = "ap-northeast-2"
}
resource "aws_acm_certificate" "cert" {
  provider = aws.ap_northeast_2
  domain_name       = "mkcloud.site"
  subject_alternative_names = ["mkcloud.site", "kgh.mkcloud.site"]
  validation_method = "DNS"

   lifecycle {
    create_before_destroy = true
  }

   tags = {
    Name = "mkcloud.site-kgh"
    Owner = var.owner-tag
  }
}

# ACM 검증
resource "aws_acm_certificate_validation" "cert_val" {
  provider = aws.ap_northeast_2
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
  depends_on = [aws_route53_record.cert_validation]

}

# ACM 검증을 위한 CNAME 레코드 생성
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
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
  zone_id         = data.aws_route53_zone.zone.zone_id
}

resource "aws_route53_record" "alb-web" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "web.${var.domain-name}"
  type    = "A"
  ttl     = 86400
  records = [aws_lb.alb-web.dns_name]
}