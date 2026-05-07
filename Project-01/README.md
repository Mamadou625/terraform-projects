# Project-01 — AWS Dev Environment with Terraform

Provisions a fully networked AWS development environment with a Docker-ready EC2 instance, using Terraform.

## Architecture

```
VPC (10.10.0.0/16)
└── Public Subnet (10.10.1.0/24) — ca-central-1a
    ├── Internet Gateway
    ├── Route Table (0.0.0.0/0 → IGW)
    └── EC2 Instance (t2.micro, Amazon Linux 2023)
        ├── Security Group (SSH :22 inbound)
        └── Key Pair (ed25519)
```

## Resources Created

| Resource | Name | Description |
|---|---|---|
| `aws_vpc` | dev-vpc | VPC with DNS support enabled |
| `aws_subnet` | dev-public-subnet | Public subnet with auto-assign public IP |
| `aws_internet_gateway` | dev-internet-gateway | Internet gateway for public access |
| `aws_route_table` | dev-public-route-table | Route table with default route to IGW |
| `aws_security_group` | dev-security-group | Allows SSH (port 22) inbound, all outbound |
| `aws_key_pair` | Project-01-Key-Pair | Uses `~/.ssh/id_ed25519.pub` |
| `aws_instance` | dev-ec2-instance | Amazon Linux 2023, t2.micro |

## EC2 User Data

On first boot the instance automatically installs:
- **Docker** (via `amazon-linux-extras`)
- **Docker Compose** (latest release)
- `ec2-user` is added to the `docker` group for rootless usage

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.0
- AWS CLI configured with credentials that have EC2/VPC permissions
- An ed25519 SSH key at `~/.ssh/id_ed25519.pub`

## Usage

```bash
# Initialize Terraform and download the AWS provider
terraform init

# Preview the changes
terraform plan

# Apply the infrastructure
terraform apply

# Connect to the instance after apply
ssh -i ~/.ssh/id_ed25519 ec2-user@<public-ip>

# Tear down all resources
terraform destroy
```

## Configuration

| Setting | Value |
|---|---|
| AWS Region | `ca-central-1` |
| AWS Provider | `hashicorp/aws ~> 6.0` |
| AMI | Amazon Linux 2023 (`al2023-ami-2023.11.20260505.0-kernel-6.1-x86_64`) |
| VPC CIDR | `10.10.0.0/16` |
| Subnet CIDR | `10.10.1.0/24` |
| Instance type | `t2.micro` |

## Files

```
.
├── providers.tf      # Terraform and AWS provider configuration
├── datasources.tf    # AMI data source lookup
├── main.tf           # All AWS resources
├── userdata.tpl      # EC2 bootstrap script (Docker install)
└── README.md
```
