#!/bin/bash

# This script fetches the public and private IPs of EC2 instances using the AWS CLI
# and generates the Ansible inventory file.

# Go to the root directory of the project
cd "$(dirname "$0")/../"

# Generate Terraform output in JSON format
cd terraform
terraform output -json > ../ansible/inventory.json

# Go to the Ansible directory
cd ../ansible

# Fetch the public IPs of EC2 instances with names starting with "wordpress-instance-"
wordpress_public_ips1=($(aws ec2 describe-instances --filters "Name=tag:Name,Values=wordpress-instance-1" --query 'Reservations[*].Instances[*].[PublicIpAddress]' --output text))
wordpress_public_ips2=($(aws ec2 describe-instances --filters "Name=tag:Name,Values=wordpress-instance-2" --query 'Reservations[*].Instances[*].[PublicIpAddress]' --output text))

# Fetch the private IP of the "database-instance"
database_private_ip=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=database-instance" --query 'Reservations[*].Instances[*].[PrivateIpAddress]' --output text)

# Fetch the public IP of the "database-instance"
database_public_ip=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=database-instance" --query 'Reservations[*].Instances[*].[PublicIpAddress]' --output text)

# Create the Ansible inventory file
cat > ansible_inventory.ini << EOL
[database]
database-instance ansible_host_private=$database_private_ip ansible_host_public=$database_public_ip ansible_user=ec2-user ansible_ssh_private_key_file=./wordpress-key.pem

[wordpress]
wordpress-instance-1 ansible_host=$wordpress_public_ips1 ansible_user=ec2-user ansible_ssh_private_key_file=./wordpress-key.pem
wordpress-instance-2 ansible_host=$wordpress_public_ips2 ansible_user=ec2-user ansible_ssh_private_key_file=./wordpress-key.pem
EOL

# Fetch the value of "efs_dns_name" from Terraform output
efs_dns_name=$(jq -r '.efs_dns_name.value' inventory.json)

# Create a new file "efs_dns_name.yml" in the "vars" directory
echo "efs_dns_name: $efs_dns_name" > vars/efs_dns_name.yml
