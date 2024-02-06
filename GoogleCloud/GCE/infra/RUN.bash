#!/bin/bash

# Find api file
found_file=$(find "../.." -type f -name 'starlit-cycle*')

# Get project name
file_name=$(basename "$found_file")
trimmed_name=$(echo "$file_name" | cut -d '-' -f 1-3)

# Change variable gcp_procjet value to name of the project
cd terraform
sed -i '' "s/gcp_project *= *\"[^\"]*\"/gcp_project = \"$trimmed_name\"/" terraform.tfvars

# Create a GCP instance with Terraform.
terraform init
terraform apply -auto-approve
