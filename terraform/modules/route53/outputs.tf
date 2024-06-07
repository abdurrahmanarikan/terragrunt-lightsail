output "zone_id" {
  description = "ID of the Route53 zone"
  value       = aws_route53_zone.main.zone_id
}

output "record_name" {
  description = "Name of the Route53 record"
  value       = aws_route53_record.www.name
}
