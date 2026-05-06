#creation of my my ami
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["a137112412989mazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.11.20260505.0-kernel-6.1-x86_64"]
  }
}
