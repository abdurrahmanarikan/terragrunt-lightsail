provider "aws" {
  region = "us-east-1"  
}

resource "aws_lightsail_instance" "test" {
  name              = "test-instance"
  availability_zone = "eu-north-1"  
  blueprint_id      = "ubuntu_20_04"
  bundle_id         = "nano_3_0"

  key_pair_name = aws_lightsail_key_pair.test.key_pair_name

  tags = {
    Name = "test-instance"
  }
}

resource "aws_lightsail_key_pair" "lgthsl" {
  name       = "lgthsl-key-pair"
  public_key = file("~/.ssh/id_rsa.pub")  
}

resource "aws_route53_record" "lightsail_dns" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "www"
  type    = "A"
  ttl     = "300"

  records = [aws_lightsail_instance.test.public_ip_address]
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.selected.zone_id

  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

data "aws_route53_zone" "selected" {
  name = "test.com."  
}

resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "test-cert"
  }
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

output "instance_ip" {
  value = aws_lightsail_instance.test.public_ip_address
}

output "certificate_arn" {
  value = aws_acm_certificate.cert.arn
}
