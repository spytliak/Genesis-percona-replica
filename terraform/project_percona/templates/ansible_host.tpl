[master]
${master_name} ansible_host=${master_public_ip} private_ip=${master_private_ip} server_id=101

[slave]
%{ for name in slave_names ~} ${name} %{ endfor ~} 
ansible_host=%{ for ip in slave_public_ips ~} ${ip} %{ endfor ~} 
private_ip=%{ for ip in slave_private_ips ~} ${ip} %{ endfor ~} 
server_id=102

[all:vars]
ansible_ssh_user = ${ansible_ssh_user}
ansible_ssh_private_key_file = ${ansible_ssh_private_key_file}
