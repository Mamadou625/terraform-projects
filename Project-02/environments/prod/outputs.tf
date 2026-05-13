output "vpc_id" {
  description = "The ID of the prod VPC"
  value       = module.vpc.vpc_id
}

output "subnet_id" {
  description = "The ID of the prod Subnet"
  value       = module.subnet.subnet_id
}

output "instance_id" {
  description = "The ID of the prod EC2 instance"
  value       = module.ec2.instance_id
}

output "public_ip" {
  description = "The public IP of the prod EC2 instance"
  value       = module.ec2.public_ip
}
