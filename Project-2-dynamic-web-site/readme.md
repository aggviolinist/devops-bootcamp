# Dynamic Site Hosting on AWS
## 1. Network Setup
### NAT Gateway
- Create a NAT Gateway in a public subnet.
- Link the NAT Gateway to the Private Route Table.
💡 This enables outbound internet access for resources in private subnets (e.g., web servers and databases) without exposing them publicly.

### 2. Security Groups
Create and configure the following security groups to control network access between components:
 ```sh
  EC2 Instance Connect Endpoint (EC2 Connect)
   - Inbound: None required
   - Outbound: VPC CIDR block

💡Used to SSH into EC2 instances without needing a Bastion Host.
 ```
 ```sh
 Application Load Balancer (ALB)
 - Inbound:
   - Port 80 (HTTP)
   - Port 443 (HTTPS)
 - Outbound: 0.0.0.0/0
💡 Routes traffic from the internet to web servers.

 ```
 ```sh
 - Web Server
  - Inbound: From ALB (for HTTP/HTTPS traffic), From EC2 Connect Endpoint (for SSH access)
  - Outbound: 0.0.0.0/0
💡 Hosts your application code and communicates with RDS for dynamic data.
```
```sh
 Data Migration Service (DMS)
 - Inbound: EC2 Connect Endpoint
 - Outbound: 0.0.0.0/0
💡 Used for migrating data to the EC2 instance (e.g., from on-prem or other sources).
```
```sh
 RDS (Database)
 - Inbound: From Web Server (MySQL port, e.g., 3306), From EC2 Connect Endpoint (for admin access)
 - Outbound: General (VPC internal / 0.0.0.0/0)
💡 Stores your dynamic site’s MySQL data.
```

### 3. EC2 Instance Connect Endpoint
In the VPC Console, under Private Connections, create an EC2 Instance Connect Endpoint.

💡This enables secure SSH access to private EC2 instances without exposing port 22 publicly or using a Bastion Host.

### 4. Storage (S3)
Create an S3 bucket 
```sh 
aws s3 mb s3://dev-app-webfile
```

Upload both: Web application files (e.g., HTML, CSS, PHP, SQL) 
```sh
aws s3 cp ./nest.zip s3://dev-app-webfile/
aws s3 cp ./V1__nest.sql  s3://dev-app-webfile/
aws s3 cp ./NestAppServiceProvider.php s3://dev-app-webfile/

 ```
Big files are not accepted on git so clear them from git
```sh
git filter-repo --path "Project 2 Dynamic site/nest.zip" --invert-paths
git push origin main --force
```
### 5. IAM 
Create a custom policy 
This policy does the following:
- Gives EC2 specific permisions with 
   - S3: ListBucket, GetObject
   - Secerets Manager: GetSecretValue, DescribeSecret
Create the role and add our custom policy
 ```sh
 dev-role-s3-secrets-manager
```

### 5. RDS
Create the Subnet group: Select the database subnets
Create the MYSQL RDS using the Subnet Group created above
  - Use Standard create
  - Use updated DB engine
  - Use Secret Manager to manage credentials
  - Create an Initial Database Name
### 6. EC2(Database Migrator)
Create an EC2 instance to migrate the SQL to RDS
 - Proceed without Key pair, we don't need to SSH publicly 
 - Add our IAM role ` dev-role-s3-secrets-manager` so our EC2 can get access to S3 and Secrets manager
 - `Connect using a Private IP` since we have our `EC2 Instance Connect Endpoint`
 - SSH into the Instance and Copy the Database from S3 to RDS using `db-migrate-script.sh`

### 7. EC2 (Web Server)
Create the EC2 instance to host our server now
 - Proceed without Key pair, we don't need to SSH publicly 
 - Add our IAM role ` dev-role-s3-secrets-manager` so our EC2 can get access to S3 and Secrets manager
 - `Connect using a Private IP` since we have our `EC2 Instance Connect Endpoint`
 - SSH into the Instance and Copy the Webfiles from S3 to EC2 using `deployment-script.sh`
 - Do server config now


### 8. ALB
- First create a target group and add these success codes `200,301,302`
- Create an ALB and test using the DNS given

### 9. AMI
- Using our server, create the AMI with `Reboot instance`
   - When selected, Amazon EC2 reboots the instance so that data is at rest when snapshots of the attached volumes are taken. This ensures data consistency

### 10. Autoscaling groups
- First create the launch template
- Select the AMI
- Select the network config we created `dev-vpc`
- Turn on Health checks
- Create ASG

