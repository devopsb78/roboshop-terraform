variable "components" {
  default = ["frontend", "catalogue", "user", "cart", "payment", "shipping", "dispatch"]
}

resource "aws_instance" "instance" {

  count                  = length(var.components)
  ami                    = ami-041aaa64228c27239
  instance_type          = "t3.small"
  vpc_security_group_ids = ["sg-06080f8fcec874b2f"]

  tags = {
    Name = var.components[count.index]
  }

}

resource "aws_route53_record" "record" {
  count   = length(var.components)
  zone_id = "Z01855394W8LPHGBYO8O"
  name    = var.components[count.index]
  type    = "A"
  ttl     = 3
  records = [aws_instance.instance[count.index].private_ip]
}

module "vpc" {
  source = "./modules/vpc"

  availability_zones     = var.availability_zones
  backend_subnets        = var.backend_subnets
  db_subnets             = var.db_subnets
  default_route_table_id = var.default_route_table_id
  default_vpc_cidr       = var.default_vpc_cidr
  default_vpc_id         = var.default_vpc_id
  env                    = var.env
  frontend_subnets       = var.frontend_subnets
  public_subnets         = var.public_subnets
  vpc_cidr_block         = var.vpc_cidr_block
}

