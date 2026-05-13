module "vpc" {
  source = "./modules/vpc"

  vpc_name       = var.vpc_name
  vpc_cidr_block = var.vpc_cidr_block
}