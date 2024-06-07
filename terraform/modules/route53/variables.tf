variable "domain_name" {
  description = "The domain name to create"
  type        = string
}

variable "webserver_ip" {
  description = "51.20.70.64"
  type        = string
}

variable "load_balancer_dns_name" {
  description = "AWS lightsail load balancer dns name"
  type        = string
}

variable "load_balancer_hosted_zone_id" {
  description = "AWS lightsail load balancer zone id"
  type        = string
}
