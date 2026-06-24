



# Latest Amazon Linux 2023 AMI for the web and app tiers
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

module "vpc" {
  source = "../../modules/vpc"

  project_name              = var.project_name
  vpc_cidr_block            = var.vpc_cidr_block
  availability_zones        = var.availability_zones
  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
  app_subnet_cidr_blocks    = var.app_subnet_cidr_blocks
  db_subnet_cidr_blocks     = var.db_subnet_cidr_blocks
}

module "security_groups" {
  source = "../../modules/security_groups"

  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  app_port     = var.app_port
}

module "s3" {
  source = "../../modules/s3"

  bucket_name  = var.app_bucket_name
  app_code_dir = "${path.module}/../../application-code"
}

module "database" {
  source = "../../modules/database"

  project_name         = var.project_name
  database_name        = var.db_name
  master_username      = var.db_master_username
  db_subnet_group_name = module.vpc.db_subnet_group_name
  db_sg_id             = module.security_groups.db_sg_id
  instance_count       = var.db_instance_count
  instance_class       = var.db_instance_class
  skip_final_snapshot  = var.db_skip_final_snapshot
}

module "iam" {
  source = "../../modules/iam"

  project_name   = var.project_name
  app_bucket_arn = module.s3.bucket_arn
  db_secret_arn  = module.database.master_secret_arn
}

module "app_tier" {
  source = "../../modules/app_tier"

  # Ensure the app code is uploaded to S3 before instances launch and run user-data
  depends_on = [module.s3]

  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id
  app_subnet_ids        = module.vpc.app_subnet_ids
  int_alb_sg_id         = module.security_groups.int_alb_sg_id
  app_sg_id             = module.security_groups.app_sg_id
  app_port              = var.app_port
  ami_id                = data.aws_ami.al2023.id
  instance_type         = var.app_instance_type
  instance_profile_name = module.iam.instance_profile_name
  s3_bucket             = module.s3.bucket_name
  db_secret_arn         = module.database.master_secret_arn
  db_endpoint           = module.database.cluster_endpoint
  db_name               = module.database.database_name
  aws_region            = var.aws_region
  asg_min_size          = var.app_asg_min_size
  asg_max_size          = var.app_asg_max_size
  asg_desired_capacity  = var.app_asg_desired_capacity
}

module "web_tier" {
  source = "../../modules/web_tier"

  # Ensure the React build is uploaded to S3 before instances launch and run user-data
  depends_on = [module.s3]

  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  ext_alb_sg_id         = module.security_groups.ext_alb_sg_id
  web_sg_id             = module.security_groups.web_sg_id
  ami_id                = data.aws_ami.al2023.id
  instance_type         = var.web_instance_type
  instance_profile_name = module.iam.instance_profile_name
  s3_bucket             = module.s3.bucket_name
  internal_alb_dns      = module.app_tier.internal_alb_dns
  asg_min_size          = var.web_asg_min_size
  asg_max_size          = var.web_asg_max_size
  asg_desired_capacity  = var.web_asg_desired_capacity
}
