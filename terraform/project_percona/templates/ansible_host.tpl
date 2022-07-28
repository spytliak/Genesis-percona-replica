[master]
%{ for ip in master_public_ip  ~}
${ip}
%{ endfor ~}

[slave]
%{ for ip in slave_public_ips  ~}
${ip}
%{ endfor ~}

[master:vars]
ansible_ssh_user = ${ansible_ssh_user}
ansible_ssh_private_key_file = ${ansible_ssh_private_key_file}
server_id = 101
private_ip = %{ for ip in master_private_ip  ~}
${ip}
%{ endfor ~}

[slave:vars]
ansible_ssh_user = ${ansible_ssh_user}
ansible_ssh_private_key_file = ${ansible_ssh_private_key_file}
server_id = 102
private_ip = %{ for ip in slave_private_ip  ~}
${ip}
%{ endfor ~}
