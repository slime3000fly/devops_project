#!/bin/bash

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