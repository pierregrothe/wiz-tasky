#!/bin/bash
# mongodb_setup.sh
# ---------------------------------------------------------------------------
# This script installs MongoDB on an Amazon Linux 2 instance,
# configures it with authentication by creating an admin user,
# and writes a connection string to a file for demonstration purposes.
#
# Placeholders:
#   {{mongodb_admin_username}} - will be replaced with the MongoDB admin username.
#   {{mongodb_admin_password}} - will be replaced with the MongoDB admin password.
# ---------------------------------------------------------------------------

# Update packages
yum update -y

# Create a repository file for MongoDB 4.4
cat <<EOT > /etc/yum.repos.d/mongodb-org-4.4.repo
[mongodb-org-4.4]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/4.4/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc
EOT

# Install MongoDB
yum install -y mongodb-org

# Start and enable MongoDB
systemctl start mongod
systemctl enable mongod

# Give MongoDB a few seconds to initialize
sleep 10

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

# Write the connection string to a file for demonstration
echo "mongodb://{{mongodb_admin_username}}:{{mongodb_admin_password}}@localhost:27017/admin" > /home/ec2-user/mongodb_connection_string.txt
