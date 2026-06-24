module "vpc" {
  source = "./modules/vpc"

  vpc_name       = var.vpc_name
  vpc_cidr_block = var.vpc_cidr_block
}

module "subnet" {
  source = "./modules/subnet"
  vpc_id            = module.vpc.vpc_id
}

module "ec2" {
  source        = "./modules/ec2"
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.subnet.subnet_id
  ami_id        = var.ami_id
  instance_type = "t2.micro"
  instance_name = "project-02-ec2"
} 

module "s3" {
  source = "./modules/S3"
  
  bucket_name = var.bucket_name
}