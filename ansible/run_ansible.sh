#!/bin/bash

# Ensure Terraform is already applied and the public IP is available
export vm_public_ip=$(terraform -chdir=../terraform output -raw vm_public_ip)

# Check if vm_public_ip is set correctly
if [ -z "$vm_public_ip" ]; then
  echo "ERROR: vm_public_ip is not set correctly. Exiting."
  exit 1
fi

# Create a new inventory file (inventory_dynamic.ini)
echo "[myhosts]" > inventory_dynamic.ini
echo "${vm_public_ip} ansible_user=tommy ansible_ssh_private_key_file=~/.ssh/id_ed25519" >> inventory_dynamic.ini

# Optionally, check the contents of the generated inventory file
cat inventory_dynamic.ini

# Run the Ansible playbook with the dynamically generated inventory
ansible-playbook -i inventory_dynamic.ini install_azure_cli.yml

