#!/bin/bash
# mongodb_setup.sh
# ---------------------------------------------------------------------------
# This script installs and configures MongoDB 8.x on an Amazon Linux 2023
# instance.
#
# Steps:
# 1. Update system packages.
# 2. Create the MongoDB 8.x repository file.
# 3. Install MongoDB packages.
# 4. Start MongoDB and enable it on boot.
# 5. Wait until MongoDB is active.
# 6. Configure MongoDB authentication by creating an admin user.
# 7. Restart MongoDB to enforce authentication.
# 8. Write a connection string to a file for demonstration purposes.
#
# Placeholders (to be replaced via Terraform's template_file data source):
#   {{mongodb_admin_username}} - MongoDB admin username.
#   {{mongodb_admin_password}} - MongoDB admin password.
# ---------------------------------------------------------------------------

# 1. Update all system packages.
sudo dnf update -y

# 2. Create the MongoDB 8.x repository file.
sudo tee /etc/yum.repos.d/mongodb-org-8.0.repo <<EOF
[mongodb-org-8.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2023/mongodb-org/8.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-8.0.asc
EOF

# 3. Install MongoDB packages.
sudo dnf install -y mongodb-org

# 4. Start MongoDB and enable it on boot.
sudo systemctl start mongod
sudo systemctl enable mongod

# 5. Wait until MongoDB is active (with a timeout).
TIMEOUT=60
while true; do
  STATUS=$(sudo systemctl is-active mongod)
  if [ "$STATUS" = "active" ]; then
    echo "MongoDB is active."
    break
  fi
  sleep 5
  TIMEOUT=$((TIMEOUT - 5))
  if [ $TIMEOUT -le 0 ]; then
    echo "MongoDB did not start within the expected time."
    exit 1
  fi
done

# 6. Configure MongoDB authentication by creating an admin user.
# The placeholders will be replaced by Terraform's template_file data source.
mongosh <<EOF_MONGO
use admin
db.createUser({
  user: "{{mongodb_admin_username}}",
  pwd: "{{mongodb_admin_password}}",
  roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
})
EOF_MONGO

# 7. Restart MongoDB to enforce authentication.
sudo systemctl restart mongod

# 8. Write the connection string to a file for demonstration.
echo "mongodb://{{mongodb_admin_username}}:{{mongodb_admin_password}}@localhost:27017/admin" | sudo tee /home/ec2-user/mongodb_connection_string.txt
