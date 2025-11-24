# DevOps Quick Reference Guide

## AWS Configuration
## Install AWS CLI
```sh
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
### Initial Setup
```bash
# Configure AWS credentials
aws configure
```

## GitHub SSH Setup

### Generate SSH Key Pairs
```bash
# Generate ED25519 key pair
ssh-keygen -t ed25519
```

---

## Git Operations

### Repository Setup
```bash
# Clone repository from GitHub
git clone https://github.com/username/repository-name.git

# Navigate into repository
cd repository-name
```

### Basic Git Workflow
```bash
# Check repository status
git status

# Stage all changes
git add .

# Commit changes
git commit -m "Committing all files"

# Push to remote repository
git push origin main
```

### Git Large File Storage (LFS)
For files larger than 100MB:

```bash
# Install Git LFS (one-time setup per machine)
sudo apt update
sudo apt install git-lfs
git lfs install

# Track large files by extension
git lfs track "*.zip"

# Add the .gitattributes file
git add .gitattributes

# Add large file
git add Project-3-resources/app/shopwise.zip

# Commit and push
git commit -m "Add large ZIP file using Git LFS"
git push
```

---

## Docker Management

### System Cleanup
```bash
# Remove all images and volumes
docker system prune -a --volumes -f
```

---

## Script Permissions

### Windows (PowerShell)
```powershell
# Set execution policy
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser

# Unblock script files
Unblock-File -Path .\build-image.ps1
Unblock-File -Path .\push-image.ps1
```

### Mac/Linux (Bash)
```bash
# Make scripts executable
chmod +x build_image.sh
chmod +x push_image.sh
```

---

## AWS ECS Operations

### Prerequisites

#### IAM Permissions
Ensure the ECS task role has these policies:
- `AmazonSSMFullAccess`
- `AmazonECSTaskExecutionRolePolicy`

#### Session Manager Plugin

**macOS:**
```bash
brew install session-manager-plugin
session-manager-plugin --version
```

**Windows:**
Download and install from:
```
https://s3.amazonaws.com/session-manager-downloads/plugin/latest/windows/SessionManagerPluginSetup.exe
```

### SSH into ECS Container

**Step 1: Enable Execute Command**
```bash
# PowerShell
aws ecs update-service `
    --cluster dev-ecs-cluster `
    --service nest-service `
    --enable-execute-command `
    --force-new-deployment

# Bash
aws ecs update-service \
    --cluster dev-ecs-cluster \
    --service nest-service \
    --enable-execute-command \
    --force-new-deployment
```

**Step 2: Check Service Status**
```bash
# PowerShell
aws ecs describe-services `
    --cluster dev-ecs-cluster `
    --services nest-service

# Bash
aws ecs describe-services \
    --cluster dev-ecs-cluster \
    --services nest-service
```

**Step 3: Get Task ARN**
```powershell
# PowerShell
$taskArn = (aws ecs list-tasks --cluster dev-ecs-cluster --service-name nest-service --query 'taskArns[0]' --output text)
```

```bash
# Bash
taskArn=$(aws ecs list-tasks --cluster dev-ecs-cluster --service-name nest-service --query 'taskArns[0]' --output text)
```

**Step 4: Execute Command**
```bash
# PowerShell
aws ecs execute-command `
    --cluster dev-ecs-cluster `
    --task $taskArn `
    --container nest `
    --interactive `
    --command "/bin/sh"

# Bash
aws ecs execute-command \
    --cluster dev-ecs-cluster \
    --task $taskArn \
    --container nest \
    --interactive \
    --command "/bin/sh"
```

---

## EC2 Connections

### Connect via EC2 Instance Connect Endpoint
```bash
aws ec2-instance-connect ssh --instance-id <instance-id>
```

---

## Notes

- Always ensure proper IAM permissions before executing ECS commands
- Git LFS is required for files exceeding GitHub's 100MB limit
- Session Manager plugin is required for ECS container access
- Use `docker system prune` carefully as it removes all unused containers, images, and volumes
