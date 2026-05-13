# Creation of my security group
resource "aws_security_group" "sg" {
    name        = var.sg_name
    description = "Security group for EC2 instance"
    vpc_id      = var.vpc_id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}       

# Creation of my EC2 instance
resource "aws_instance" "ec2" {
    ami                         = var.ami_id
    instance_type               = var.instance_type
    subnet_id                   = var.subnet_id
    vpc_security_group_ids      = [aws_security_group.sg.id]
    associate_public_ip_address = true

    tags = {
      Name = var.instance_name
    }
}