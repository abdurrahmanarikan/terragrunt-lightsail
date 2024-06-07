resource "aws_route53_zone" "main" {
  name = var.domain_name
}

resource "aws_route53_record" "sub1" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "sub1"
  type    = "CNAME"
  ttl     = 300
  records = [var.webserver_ip]

  alias {
    name                   = var.load_balancer_dns_name
    zone_id                = var.load_balancer_hosted_zone_id
    evaluate_target_health = true
  }
}
