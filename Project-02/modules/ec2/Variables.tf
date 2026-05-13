variable "sg_name" {
    description = "Name of the Security Group"
    type = string
    default = "project-02-sg"   
  
}

variable "vpc_id" {
    description = "The ID of the VPC"
    type = string
  
}

variable "ami_id" {
    description = "The ID of the AMI"
    type = string
  
}

variable "instance_type" {
    description = "The type of the EC2 instance"
    type = string
    default = "t2.micro"
}

variable "subnet_id" {
    description = "The ID of the Subnet"
    type = string
  
}

variable "instance_name" {
    description = "Name of the EC2 instance"
    type = string
    default = "project-02-ec2"
}
