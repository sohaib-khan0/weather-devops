#!/bin/bash

# Build Docker image
docker build -t weather-app .

# Authenticate with AWS ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com

# Tag and push image
docker tag weather-app:latest ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/weather-app:latest
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/weather-app:latest

# Apply Terraform
cd infrastructure
terraform init
terraform apply -auto-approve -var="weather_api_key=${WEATHER_API_KEY}"
