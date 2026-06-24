#!/bin/bash
set -euxo pipefail

# --- App tier bootstrap (Node.js + pm2) on Amazon Linux 2023 ---

dnf update -y

# Install Node.js straight from the Amazon Linux 2023 repo (reliable in the
# non-interactive root user-data context; avoids nvm/profile issues) plus the
# build tooling and python3 needed for npm installs and the secret parsing.
dnf install -y nodejs npm gcc-c++ make python3
npm install -g pm2

# Pull the app-tier source from S3
mkdir -p /home/ec2-user/app-tier
aws s3 cp s3://${s3_bucket}/app-tier/ /home/ec2-user/app-tier/ --recursive
cd /home/ec2-user/app-tier
npm install

# Fetch DB credentials from Secrets Manager (managed by Aurora) and write DbConfig.js.
# db_endpoint / db_name are injected by templatefile; username/password come from the secret.
SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id "${db_secret_arn}" --query SecretString --output text --region ${aws_region})
DB_USER=$(echo "$SECRET_JSON" | python3 -c "import sys,json;print(json.load(sys.stdin)['username'])")
DB_PWD=$(echo "$SECRET_JSON" | python3 -c "import sys,json;print(json.load(sys.stdin)['password'])")

cat > /home/ec2-user/app-tier/DbConfig.js <<EOF
module.exports = Object.freeze({
    DB_HOST : '${db_endpoint}',
    DB_USER : '$DB_USER',
    DB_PWD : '$DB_PWD',
    DB_DATABASE : '${db_name}'
});
EOF

# Seed the schema the app expects (idempotent; app instances can reach Aurora).
# Best-effort: a transient DB hiccup must not fail the instance health check.
dnf install -y mariadb105 || true
mysql -h "${db_endpoint}" -u "$DB_USER" -p"$DB_PWD" -e \
  "CREATE DATABASE IF NOT EXISTS ${db_name}; USE ${db_name}; CREATE TABLE IF NOT EXISTS transactions (id INT NOT NULL AUTO_INCREMENT, amount DECIMAL(10,2), description VARCHAR(100), PRIMARY KEY (id));" || true

# Start the Node app (listens on port 4000) and persist across reboots
pm2 start index.js --name app-tier
pm2 save
pm2 startup systemd -u root --hp /root
