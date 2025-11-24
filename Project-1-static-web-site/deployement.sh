#!/bin/bash

# Create an environment variable for the S3 zip file
export S3_URI="dev-app-webfile"

# Update the packages on the EC2 instance
sudo yum update -y

# Install the Apache HTTP Server  
sudo yum install -y httpd

# Change to the Apache web root directory
cd /var/www/html

# Remove any existing files
sudo rm -rf *

# Download the zip file from the S3 bucket
sudo aws s3 cp "$S3_URI" .

# Unzip the downloaded file
sudo unzip jupiter.zip

# Copy the contents to the html directory
sudo cp -R jupiter/. .
sudo cp -R ../'project 1 assets'/jupiter/. .
sudo cp -R jupiter/. ../html/


# Clean up zip file and extracted folder
sudo rm -rf jupiter jupiter.zip

# Enable and start Apache service
sudo systemctl enable httpd
sudo systemctl start httpd

## Fixing the errors and why it doesnt display
# Move into /var/www/html
cd /var/www/html

# Move all files from the nested html/ folder up one level
sudo mv html/* .

# Remove the now-empty extra html folder
sudo rm -rf html
