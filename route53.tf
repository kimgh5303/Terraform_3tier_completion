/*

# ACM 인증서 생성
resource "aws_acm_certificate" "example" {
  domain_name       = "web.mycomet.link"
  validation_method = "DNS"

   tags = {
    Name = "mycomet.link-ACM"
    Owner = var.owner-tag
  }
}

# ACM 검증
resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = aws_acm_certificate.example.arn
  
}

data "aws_route53_zone" "example" {
  name         = "mycomet.link"
  private_zone = false

  tags = {
    Name = "mycomet.link"
    Owner = var.owner-tag
  }
}

# ACM 검증을 위한 CNAME 레코드 생성
resource "aws_route53_record" "example" {
  for_each = {
    for dvo in aws_acm_certificate.example.domain_validation_options : dvo.domain_name => {
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
  zone_id         = data.aws_route53_zone.example.zone_id


}

# ALB(WEB)에 CNAME 레코드로 DNS 값 입력
resource "aws_route53_record" "web" {
  zone_id = data.aws_route53_zone.example.zone_id
  name    = "web.mycomet.link"
  type    = "CNAME"
  ttl     = 86400
  records = [aws_lb.alb-web.dns_name]
}

*/