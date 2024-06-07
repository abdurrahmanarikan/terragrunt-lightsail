resource "aws_lightsail_instance" "web" {
  name              = var.name
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_3_0"
  availability_zone = var.availability_zone

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y docker
              sudo service docker start
              sudo systemctl enable docker
              docker run -d -p 5678:5678 hashicorp/http-echo -text="${var.ECHO_TEXT}"
              EOF
}

resource "aws_lightsail_instance_public_ports" "webserver_ports" {
  instance_name = aws_lightsail_instance.web.name
  port_info {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  port_info {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  port_info {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }
  port_info {
    from_port   = 5678
    to_port     = 5678
    protocol    = "tcp"
  }
}