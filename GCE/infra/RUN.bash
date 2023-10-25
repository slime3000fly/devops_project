#!/bin/bash

# Find api file
found_file=$(find "../.." -type f -name 'starlit-cycle*')

# Get project name
file_name=$(basename "$found_file")
trimmed_name=$(echo "$file_name" | cut -d '-' -f 1-3)

sed -i '' "s/gcp_project *= *\"[^\"]*\"/gcp_project = \"$trimmed_name\"/" terraform.tfvars

# Create a GCP instance with Terraform.
terraform init
terraform apply

# Read the IP address from the 'ip.txt' file and store it in the 'value' variable.
value_master=$(head -1 ip.txt)
echo "Instance IP address: $value_master, $value_worker"  # Print the IP address to the console.

master="master ansible_host=$value_master ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_rsa"
sleep 60

# Create or overwrite the 'hosts.ini' file for the Ansible script.
touch hosts.ini
echo -e "[all]\n$master\n[master_server]\n$master"> hosts.ini


# Run an Ansible script
ansible-playbook main.yml -i hosts.ini --ask-vault-pass