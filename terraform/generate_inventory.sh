#!/bin/bash

echo "A iniciar script"
pwd

VM_IP=$(terraform output -raw vm_public_ip)

# Write the dynamic inventory file for Ansible
cat > ../ansible/inventory.ini <<EOL
[myhosts]
$VM_IP ansible_user=tommy ansible_ssh_private_key_file=~/.ssh/id_ed25519 ansible_ssh_extra_args="-o StrictHostKeyChecking=no"
EOL
