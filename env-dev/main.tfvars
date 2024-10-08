env           = "dev"
instance_type = "t3.small"
zone_id       = "Z01855394W8LPHGBYO8O"

#vpc
vpc_cidr_block         = "10.10.0.0/24"
default_vpc_id         = "vpc-05f7d6dce620750fd"
default_vpc_cidr       = "172.31.0.0/16"
default_route_table_id = "rtb-0e77d8908ea983bdb"

frontend_subnets    = ["10.10.0.0/27", "10.10.0.32/27"]
backend_subnets     = ["10.10.0.64/27", "10.10.0.96/27"]
db_subnets          = ["10.10.0.128/27", "10.10.0.160/27"]
public_subnets      = ["10.10.0.192/27", "10.10.0.224/27"]
availability_zones  = ["us-east-1a", "us-east-1b"]
#rds
bastion_nodes       = ["172.31.90.56/32"]
prometheus_nodes    = ["172.31.94.146/32"]
certificate_arn     = "arn:aws:acm:us-east-1:368761340104:certificate/55f0d04d-1722-4dad-9590-a310adf913af"
kms_key_id          = "arn:aws:kms:us-east-1:368761340104:key/21fae37b-2fad-4b3d-9d86-45025333e494"

#asg
max_capacity      = 5
min_capacity      = 1

docdb = {
  main = {
    family         = "docdb4.0"
    instance_class = "db.t3.medium"
    instance_count = 1
    engine_version = "4.0.0"

  }
}

rds = {
  main = {
    allocated_storage   = 20
    engine_version      = "5.7.44"
    family              = "mysql5.7"
    instance_class      = "db.t3.micro"
    skip_final_snapshot = true
    storage_type        = "gp3"
  }
}

rabbitmq = {
  main = {
    component     = "rabbitmq"
    instance_type = "t3.small"
  }
}

elasticache = {
  main = {
    engine_version          = "6.2"
    family                  = "redis6.x"
    node_type               = "cache.t4g.micro"
  }
}




