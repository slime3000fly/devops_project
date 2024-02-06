#!/bin/bash

# Find api file
found_file=$(find "../.." -type f -name 'starlit-cycle*')

# Get project name
file_name=$(basename "$found_file")
trimmed_name=$(echo "$file_name" | cut -d '-' -f 1-3)

# Create a GKE instance with Terraform.
cd terraform

sed -i '' "s/gcp_project *= *\"[^\"]*\"/gcp_project = \"$trimmed_name\"/" terraform.tfvars

terraform init
terraform apply

cd ..

gcloud container clusters get-credentials devops-cluster --zone europe-central2-a --project $trimmed_name

kubectl apply -f deployment.yml
kubectl apply -f LoadBalancer.yml