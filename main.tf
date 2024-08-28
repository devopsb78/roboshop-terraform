variable "components" {
  default = ["frontend", "catalogue", "user", "cart", "payment", "shipping", "dispatch"]
}

resource "aws_instance" "instance" {

  count                  = length(var.components)
  ami                    = "ami-041aaa64228c27239"
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

module "docdb" {
  for_each = var.docdb
  source   = "./modules/docdb"

  env                     = var.env
  family                  = each.value["family"]
  instance_class          = each.value["instance_class"]
  instance_count          = each.value["instance_count"]
  engine_version          = each.value["engine_version"]
  server_app_port_sg_cidr = var.backend_subnets
  subnet_ids              = module.vpc.db_subnets
  vpc_id                  = module.vpc.vpc_id
  kms_key_id              = var.kms_key_id
}