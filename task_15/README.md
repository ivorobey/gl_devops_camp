### INTRODUCTION

_Terraform:_
- create VPC in GCP	
- create instance with External IP		
- prepare managed DB (MySQL)		
			
_Ansible:_
- (optional) perform basic hardening (keyless-only ssh, unattended upgrade, firewall)			
- deploy K8s (single-node cluster via Kubespray)		
			
_Kubernetes:_
- prepare ansible-playbook for deploying Wordpress		
- deploy WordPress with connection to DataBase

For performing all of those steps the techs needed are:
- Terraform
- Ansible
- Kubernetes cluster
- GCP account:
  - with access to the CC resources
  - service account with right permissions
  - API-services enabled

![image](https://user-images.githubusercontent.com/42977616/221235971-f77a8bb0-b703-4d25-9fa7-6b8d710d6907.png)
