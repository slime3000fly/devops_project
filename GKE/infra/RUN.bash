#!/bin/bash

# Create a GKE instance with Terraform.
cd terrafrom

terraform init
terraform apply

cd ..
# Find api file
found_file=$(find "../.." -type f -name 'starlit-cycle*')

# Get project name
file_name=$(basename "$found_file")
trimmed_name=$(echo "$file_name" | cut -d '-' -f 1-3)

gcloud container clusters get-credentials my-gke-cluster --zone europe-central2-a --project $trimmed_name

kubectl apply -f deployment.yml
kubectl apply -f LoadBalancer.yml