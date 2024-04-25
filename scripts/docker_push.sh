#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
    export $(cat .env | sed 's/#.*//g' | xargs)
else
    echo "Error: .env file not found."
    exit 1
fi

# Define a function for logging
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Step 1: Build the Docker image
log "Building the Docker image..."
docker build -t ${REPOSITORY_NAME} .
if [ $? -ne 0 ]; then
    log "Error: Docker build failed"
    exit 1
fi

# Step 2: Authenticate to Amazon ECR
log "Authenticating to AWS ECR..."
aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com
if [ $? -ne 0 ]; then
    log "Error: Failed to authenticate to ECR"
    exit 1
fi

# Step 3: Tag the Docker image for ECR
log "Tagging the image..."
docker tag ${REPOSITORY_NAME}:${IMAGE_TAG} ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${REPOSITORY_NAME}:${IMAGE_TAG}
if [ $? -ne 0 ]; then
    log "Error: Failed to tag the image"
    exit 1
fi

# Step 4: Push the image to Amazon ECR
log "Pushing the image to AWS ECR..."
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${REPOSITORY_NAME}:${IMAGE_TAG}
if [ $? -ne 0 ]; then
    log "Error: Failed to push the image to ECR"
    exit 1
fi

log "Docker image pushed successfully to ECR!"

# Exit successfully
exit 0
