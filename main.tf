variable "components" {
  default = ["frontend", "catalogue", "user", "cart", "payment", "shipping", "dispatch"]
}

resource "aws_instance" "instance" {

  count                  = length(var.components)
  ami                    = "ami-0b4f379183e5706b9"
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

module "rds" {
  for_each = var.rds
  source   = "./modules/rds"

  allocated_storage       = each.value["allocated_storage"]
  engine_version          = each.value["engine_version"]
  family                  = each.value["family"]
  instance_class          = each.value["instance_class"]
  skip_final_snapshot     = each.value["skip_final_snapshot"]
  storage_type            = each.value["storage_type"]
  component               = "rds"
  engine                  = "mysql"
  env                     = var.env
  server_app_port_sg_cidr = var.backend_subnets
  subnet_ids              = module.vpc.db_subnets
  vpc_id                  = module.vpc.vpc_id
  kms_key_id              = var.kms_key_id
}

module "rabbitmq" {
  for_each = var.rabbitmq
  source   = "./modules/rabbitmq"

  instance_type           = each.value["instance_type"]
  component               = each.value["component"]
  env                     = var.env
  bastion_nodes           = var.bastion_nodes
  kms_key_id              = var.kms_key_id
  server_app_port_sg_cidr = var.backend_subnets
  subnet_ids              = module.vpc.db_subnets
  vpc_id                  = module.vpc.vpc_id
  zone_id                 = var.zone_id
}

module "elasticache" {
  for_each = var.elasticache
  source   = "./modules/elasticache"

  engine_version          = each.value["engine_version"]
  family                  = each.value["family"]
  node_type               = each.value["node_type"]
  env                     = var.env
  server_app_port_sg_cidr = var.backend_subnets
  subnet_ids              = module.vpc.db_subnets
  vpc_id                  = module.vpc.vpc_id
}

