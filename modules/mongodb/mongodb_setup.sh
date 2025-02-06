#!/bin/bash
# mongodb_setup.sh
# ---------------------------------------------------------------------------
# This script installs and configures MongoDB 8.x on an Amazon Linux 2 instance.
# It ensures the Amazon SSM Agent is installed and running, sets up the MongoDB
# repository per the MongoDB manual, installs MongoDB, creates an admin user,
# and writes a connection string to a file for demonstration purposes.
#
# Placeholders:
#   {{mongodb_admin_username}} - MongoDB admin username.
#   {{mongodb_admin_password}} - MongoDB admin password.
# ---------------------------------------------------------------------------

# Update packages
yum update -y


# Ensure Amazon SSM Agent is installed and running
#if ! command -v amazon-ssm-agent &> /dev/null; then
#  echo "SSM Agent not found. Installing..."
#  yum install -y amazon-ssm-agent
#fi
#systemctl enable amazon-ssm-agent
#systemctl start amazon-ssm-agent

# Create a repository file for MongoDB 8.x according to the official manual
cat <<EOT > /etc/yum.repos.d/mongodb-org-8.0.repo
[mongodb-org-8.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/8.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-8.0.asc
EOT

# Install MongoDB packages
yum install -y mongodb-org

# Start and enable MongoDB
systemctl start mongod
systemctl enable mongod

# Wait until MongoDB is active using a while loop with a timeout
TIMEOUT=60
while true; do
  STATUS=$(systemctl is-active mongod)
  if [ "$STATUS" == "active" ]; then
    echo "MongoDB is active."
    break
  fi
  sleep 5
  TIMEOUT=$((TIMEOUT-5))
  if [ $TIMEOUT -le 0 ]; then
    echo "MongoDB did not start within the expected time."
    exit 1
  fi
done

# Configure MongoDB authentication by creating an admin user
mongo <<EOF_MONGO
use admin
db.createUser({
  user: "{{mongodb_admin_username}}",
  pwd: "{{mongodb_admin_password}}",
  roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
})
EOF_MONGO

# Restart MongoDB to enforce authentication settings
systemctl restart mongod

# Write the connection string to a file for demonstration purposes
echo "mongodb://{{mongodb_admin_username}}:{{mongodb_admin_password}}@localhost:27017/admin" > /home/ec2-user/mongodb_connection_string.txt
