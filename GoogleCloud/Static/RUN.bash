#!/bin/bash

# Find api file
found_file=$(find "../.." -type f -name 'starlit-cycle*')

# Get project name
file_name=$(basename "$found_file")
trimmed_name=$(echo "$file_name" | cut -d '-' -f 1-3)

# change project name in terrarom vars
sed -i '' "s/gcp_project *= *\"[^\"]*\"/gcp_project = \"$trimmed_name\"/" terraform.tfvars

terraform init
terraform apply -auto-approve
