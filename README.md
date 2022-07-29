# Genesis-percona-replica
for Genesis DevOps School 

[![Percona](https://github.com/spytliak/Genesis-percona-replica/actions/workflows/main.yml/badge.svg)](https://github.com/spytliak/Genesis-percona-replica/actions/workflows/main.yml)
[![Terraform Destroy](https://github.com/spytliak/Genesis-percona-replica/actions/workflows/destroy.yml/badge.svg)](https://github.com/spytliak/Genesis-percona-replica/actions/workflows/destroy.yml)

### Description
The repo is for creating and configuring Percona Mysql Replication  
Terraform creates: VPC, 2 ec2 instances; generate ssh_key, host file for Ansible.  
Ansible installs Percona and configures Mysql Replication  

#### Supported OS
* Target linux instance should have Ubuntu >= 18 

### CI/CD 
Workflows:
* [main.yml](/.github/workflows/main.yml)               - the main workflow (Deploy: Terraform, Ansible; Report: Slack), included TF and Ansible Debug for manual troubleshooting
* [destroy.yml](/.github/workflows/destroy.yml)         - the manual terraform destroy, included TF Debug  
Jobs:
  * Deploy
  * Report
  * Terraform Destroy

### Terraform

The project is in [project_percona](/terraform/project_percona/)  

* [ansible_host.tpl](/terraform/project_percona/templates/ansible_host.tpl)         - the hosts template for Ansible  
* [hostname.tpl](/terraform/project_percona/templates/hostname.tpl)                 - the template for install host name  
* [percona.auto.tfvars](/terraform/project_percona/percona.auto.tfvars)             - the overridden project variables  
* [ansible.tf](/terraform/project_percona/ansible.tf)                               - create hosts vars for ansible, and provisioner ansible in terraform (variable **ansible** = false is by default)
* [backend.tf](/terraform/project_percona/backend.tf)                               - the backend file (s3)
* [data.tf](/terraform/project_percona/data.tf)                                     - all data of project
* [ec2.tf](/terraform/project_percona/ec2.tf)                                       - deploy EC2 instances
* [outputs.tf](/terraform/project_percona/outputs.tf)                               - all outputs (ami, ec2)
* [provider.tf](/terraform/project_percona/provider.tf)                             - the provider file
* [rsa_key.tf](/terraform/project_percona/rsa_key.tf)                               - deploy ssh key and save in local host
* [security_group.tf](/terraform/project_percona/security_group.tf)                 - deploy all security groups (for ec2)
* [variables.tf](/terraform/project_percona/variables.tf)                           - all default variables
* [vpc.tf](/terraform/project_percona/vpc.tf)                                       - deploy VPC
* [locals.tf](/terraform/project_percona/locals.tf)                                 - all locals of project

#### Directory tree - Terraform
```bash
└── project_percona
  ├── ansible.tf
  ├── backend.tf
  ├── data.tf
  ├── percona.auto.tfvars
  ├── ec2.tf
  ├── locals.tf
  ├── outputs.tf
  ├── provider.tf
  ├── variables.tf
  └── rsa_key.tf
```

### Ansible
The ansible playbooks for deploy Mysql Replication.  
The Linux user that can be used by Ansible to access the host is vars *ssh_user_name*, for Ubuntu default is **ubuntu** (in AWS, GCP, Openstack).

The playbooks are in [playbooks](/ansible/playbooks/) subdirectory.  
The roles are in [roles](/ansible/roles/) subdirectory.  

* [replica.yml](/ansible/playbooks/replica.yml)                                - the playbook for install Replica
* [replica.yml](/ansible/roles/percona/tasks/replica.yml)                      - configure Replica
* [install_percona.yml](/ansible/roles/percona/tasks/install_percona.yml)      - install Percona
* [ufw.yml](/ansible/roles/percona/tasks/ufw.yml)                              - disable ufw in ubuntu  
* [main.yml](/ansible/roles/percona/tasks/main.yml)                            - the main playbook with include all tasks  
* [mysqld.cnf.j2](/ansible/roles/percona/templates/mysqld.cnf.j2)              - the template for mysql conf 
* [main.yml](/ansible//roles/percona/defaults/main.yml)                        - the variables for role
* [all.yml](/ansible/inventory/group_vars/all/all.yml)                         - the group variables 
* [secret.yaml](/ansible/inventory/group_vars/all/secret.yml)                  - the variable with mysql password  
* [hosts.ini.example](/ansible/inventory/hosts.ini.example)                    - the hosts file example

#### Directory tree - Ansible
```bash
├── inventory
|   ├── group_vars
|   |   └── all
|   |        ├── all.yml
|   |        └── secret.yml
|   └── hosts.ini.example
|
├── playbooks
|   └── percona.yml
|
├── roles
|   └── percona
|       ├── defaults
|       |   └── main.yml
|       └── tasks
|       |   ├── install_percona.yml
|       |   ├── main.yml
|       |   ├── ufw.yml
|       |   └── replica.yml
|       └── templates
|            └── mysqld.cnf.j2
└── ansible.cfg
```