output "instance_ip" {
  description = "The public IP address of the Lightsail instance"
  value       = aws_lightsail_instance.example.public_ip_address
}

output "certificate_arn" {
  description = "The ARN of the ACM certificate"
  value       = aws_acm_certificate.cert.arn
}