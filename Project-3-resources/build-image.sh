#!/bin/bash

# ============================================
# CONFIGURATION SECTION
# ============================================

# Docker Image Configuration
export IMAGE_NAME="shopwise"
export IMAGE_TAG="latest"

# GitHub Configuration
export GITHUB_USERNAME="aggviolinist"
export REPOSITORY_NAME="devops-bootcamp"
export APPLICATION_CODE_FILE_NAME="shopwise"

# Color codes
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# ============================================
# RETRIEVE SECRETS FROM AWS SECRETS MANAGER
# ============================================

echo -e "${CYAN}Starting Docker build process for $IMAGE_NAME application...${NC}"

# Enable BuildKit
export DOCKER_BUILDKIT=1

# Run the docker build command with BuildKit secrets
docker build \
  --build-arg GITHUB_USERNAME="$GITHUB_USERNAME" \
  --build-arg REPOSITORY_NAME="$REPOSITORY_NAME" \
  --build-arg APPLICATION_CODE_FILE_NAME="$APPLICATION_CODE_FILE_NAME" \
  -t "${IMAGE_NAME}:${IMAGE_TAG}" \
  .

# Check if build was successful
if [ $? -eq 0 ]; then
  echo -e "${GREEN}Docker image $IMAGE_NAME built successfully!${NC}"
else
  echo -e "${RED}Docker build failed. Please check the error messages above.${NC}"
  exit 1
fi