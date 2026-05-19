module "vpc" {
  source = "../../modules/vpc"

  vpc_name       = var.vpc_name
  vpc_cidr_block = var.vpc_cidr_block
}

module "subnet" {
  source = "../../modules/subnet"

  project_name               = var.project_name
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  availability_zones         = var.availability_zones
  vpc_id                     = module.vpc.vpc_id
}

module "ec2" {
  source = "../../modules/ec2"

  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.subnet.public_subnet_ids[0]
  ami_id        = var.ami_id
  instance_type = var.instance_type
  instance_name = var.instance_name
  sg_name       = var.sg_name
}
