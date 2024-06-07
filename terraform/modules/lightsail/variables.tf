variable "name" {
  description = "Name of the Lightsail instance"
  type        = string
  default     = "xayn-test"
}

variable "availability_zone" {
  description = "AWS availability zone"
  type        = string
  default     = "eu-north-1a"
}

variable "ECHO_TEXT" {
  description = "Text to echo"
  type        = string
  sensitive   = true
}
