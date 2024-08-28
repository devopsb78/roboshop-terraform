variable "availability_zones" {}
variable "backend_subnets" {}
variable "db_subnets" {}
variable "default_route_table_id" {}
variable "default_vpc_cidr" {}
variable "default_vpc_id" {}
variable "env" {}
variable "frontend_subnets" {}
variable "public_subnets" {}
variable "vpc_cidr_block" {}


variable "docdb" {}
variable "rds" {}
variable "rabbitmq" {}
variable "elasticache" {}


variable "kms_key_id" {}
variable "vault_token" {}

variable "bastion_nodes" {}
variable "prometheus_nodes" {}
variable "zone_id" {}