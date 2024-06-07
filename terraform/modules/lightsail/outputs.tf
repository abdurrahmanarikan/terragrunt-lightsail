output "webserver_ip" {
  description = "IP address of the webserver"
  value       = aws_lightsail_instance.web.public_ip_address
}
