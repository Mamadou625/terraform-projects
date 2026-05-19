output "vpc_id" {
  description = "The ID of the dev VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "The IDs of the dev public subnets"
  value       = module.subnet.public_subnet_ids
}

output "private_subnet_ids" {
  description = "The IDs of the dev private subnets"
  value       = module.subnet.private_subnet_ids
}

output "instance_id" {
  description = "The ID of the dev EC2 instance"
  value       = module.ec2.instance_id
}

output "public_ip" {
  description = "The public IP of the dev EC2 instance"
  value       = module.ec2.public_ip
}
