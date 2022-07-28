#-------------------------------------------------------------------
# Create host file for ansible
#-------------------------------------------------------------------
resource "local_file" "host" {
  content = templatefile("./templates/ansible_host.tpl",
    {
      master_public_ip             = aws_instance.master[*].public_ip
      master_private_ip            = aws_instance.master[*].private_ip
      slave_public_ips             = aws_instance.slave[*].public_ip
      slave_private_ip             = aws_instance.slave[*].private_ip
      ansible_ssh_user             = var.ssh_user_name
      ansible_ssh_private_key_file = "../terraform/project_percona/${var.ssh_key["name"]}.pem"
    }
  )
  filename = "../../ansible/inventory/hosts.ini"

  depends_on = [
    aws_key_pair.ssh-key,
    aws_instance.master,
    aws_instance.slave
  ]
}

#-------------------------------------------------------------------
# Provisioner ansible for create Mysql Replication
#-------------------------------------------------------------------
resource "null_resource" "ansible" {
  count = var.ansible ? 1 : 0

  provisioner "local-exec" {
    when        = create
    on_failure  = continue
    interpreter = ["/bin/bash", "-c"]
    command     = "cd ../../ansible/ && ansible-playbook -i inventory/hosts.ini playbooks/replica.yml"
  }

  depends_on = [
    local_file.host
  ]
}