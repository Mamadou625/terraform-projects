#!/bin/bash
set -e

# Update system packages
yum update -y

# Install required dependencies for Amazon Linux 2
yum install -y ca-certificates curl git

# Install Docker using amazon-linux-extras
amazon-linux-extras install docker -y || {
  # Fallback for AL2 if amazon-linux-extras fails
  yum install -y docker
}

# Start Docker service
systemctl start docker
systemctl enable docker

# Add ec2-user to docker group (allows non-root Docker usage)
usermod -a -G docker ec2-user

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Wait for Docker daemon to be ready
sleep 5

# Verify installations
echo "Docker version:"
docker --version
echo "Docker Compose version:"
docker-compose --version
echo "Docker installation completed successfully"
