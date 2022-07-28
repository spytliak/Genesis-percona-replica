#-----------------------------------------------------------------------
# Provider region
#-----------------------------------------------------------------------
region = "us-east-1"

#-----------------------------------------------------------------------
# Hostname
#-----------------------------------------------------------------------
host_name = {
  "master" = "master"
  "slave"  = "replica"
}
#-----------------------------------------------------------------------
# SSH
#-----------------------------------------------------------------------
ssh_cidr = "212.90.62.94/32"

ssh_user_name = "ubuntu"

ssh_key = {
  "install" = true
  "name"    = "genesis_ssh_key"
}

#-----------------------------------------------------------------------
# Tags
#-----------------------------------------------------------------------
common_tags = {
  Owner   = "Serhii Pytliak"
  Project = "Genesis DevOps School"
  Email   = "serhii.pytliak@gmail.com"
}

#-----------------------------------------------------------------------
# Provisioner Ansible
#-----------------------------------------------------------------------
ansible = false

#-----------------------------------------------------------------------
# EC2
#-----------------------------------------------------------------------
vm_slave_count = 1