aws_region   = "ca-central-1"
project_name = "project-03-prod"

# Networking (2 AZs)
vpc_cidr_block            = "10.1.0.0/16"
availability_zones        = ["ca-central-1a", "ca-central-1b"]
public_subnet_cidr_blocks = ["10.1.1.0/24", "10.1.2.0/24"]
app_subnet_cidr_blocks    = ["10.1.11.0/24", "10.1.12.0/24"]
db_subnet_cidr_blocks     = ["10.1.21.0/24", "10.1.22.0/24"]

# Application code bucket (must be globally unique)
app_bucket_name = "project-03-prod-app-code-mamadou"

# Compute (prod-scaled)
web_instance_type        = "t3.small"
app_instance_type        = "t3.small"
web_asg_min_size         = 2
web_asg_max_size         = 6
web_asg_desired_capacity = 2
app_asg_min_size         = 2
app_asg_max_size         = 6
app_asg_desired_capacity = 2

# Database (prod keeps a final snapshot on destroy)
db_name                = "webappdb"
db_master_username     = "admin"
db_instance_count      = 2
db_instance_class      = "db.t3.medium"
db_skip_final_snapshot = false
