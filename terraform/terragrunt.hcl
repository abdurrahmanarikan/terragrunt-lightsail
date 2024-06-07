terraform {
  source = "../../modules/lightsail"
}

inputs = {
  name              = "webserver"
  availability_zone = "eu-north-1a"
}