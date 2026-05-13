output "vpc_id" {
  description = "The ID of the dev VPC"
  value       = module.vpc.vpc_id
}

output "subnet_id" {
  description = "The ID of the dev Subnet"
  value       = module.subnet.subnet_id
}

output "instance_id" {
  description = "The ID of the dev EC2 instance"
  value       = module.ec2.instance_id
}

output "public_ip" {
  description = "The public IP of the dev EC2 instance"
  value       = module.ec2.public_ip
}
