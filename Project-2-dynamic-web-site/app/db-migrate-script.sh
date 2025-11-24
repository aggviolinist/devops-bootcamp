#!/bin/bash

# ================================================================
# Define environment variables
# ================================================================

# Set basic environment variables
export S3_URI='s3://dev-app-webfile/V1__nest.sql'
export RDS_ENDPOINT='applicationdb.cszos622kt59.us-east-1.rds.amazonaws.com'
export FLYWAY_VERSION='11.15.0'
export RDS_DB_NAME='applicationdb'
export SECRET_NAME='rds!db-3188d327-1314-407a-9e64-dda82fd56e84'
export AWS_REGION='us-east-1'

# ================================================================
# Verify all environment variables are set
# ================================================================

# Verify all variables are set
echo "S3_URI: $S3_URI"
echo "RDS_ENDPOINT: $RDS_ENDPOINT"
echo "FLYWAY_VERSION: $FLYWAY_VERSION"
echo "RDS_DB_NAME: $RDS_DB_NAME"
echo "SECRET_NAME: $SECRET_NAME"
echo "AWS_REGION: $AWS_REGION"

# ================================================================
# Retrieve RDS database credentials from AWS Secrets Manager
# ================================================================

# Install jq if not available (for JSON parsing)
sudo yum install -y jq

# Retrieve secret from Secrets Manager
SECRET_JSON=$(aws secretsmanager get-secret-value \
  --secret-id ${SECRET_NAME} \
  --region ${AWS_REGION} \
  --query SecretString \
  --output text)

# Parse username and password from JSON
export RDS_DB_USERNAME=$(echo $SECRET_JSON | jq -r '.username')
export RDS_DB_PASSWORD=$(echo $SECRET_JSON | jq -r '.password')

# ================================================================
# Install Flyway and run database migrations
# ================================================================

# Update all packages
sudo yum update -y

# Navigate to a consistent directory
cd /home/ec2-user

# Download and extract Flyway
sudo wget -qO- https://download.red-gate.com/maven/release/com/redgate/flyway/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}-linux-x64.tar.gz | tar -xvz && sudo ln -s $(pwd)/flyway-${FLYWAY_VERSION}/flyway /usr/local/bin

# Create the SQL directory for migrations
sudo mkdir -p sql

# Download the migration SQL script from AWS S3
sudo aws s3 cp ${S3_URI} sql/

# Run Flyway migration
sudo flyway -url=jdbc:mysql://${RDS_ENDPOINT}:3306/${RDS_DB_NAME}?allowPublicKeyRetrieval=true \
  -user=${RDS_DB_USERNAME} \
  -password="${RDS_DB_PASSWORD}" \
  -locations=filesystem:sql \
  migrate