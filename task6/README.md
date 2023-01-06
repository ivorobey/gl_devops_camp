### Requirements:

```
- Create two terraform modules for provisioning one AWS and one Azure instance;
- Use variables.
- Provision one SSH public key for created instances;
- Make your instances available to everyone on the web;
- Add public IP of instances to Output Values;
- Install Grafana to your instances;
```

### AWS:
```
Input your secrets provider:
  access_key = "put_access_key"
  secret_key = "put_secret_key"
```

### Azure:
```
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az login
az ad sp create-for-rbac -n "somename" --role="Contributor" --scopes="/subscriptions/your_sub_id"
Input your secrets provider:
  subscription_id = ""
  client_id       = ""
  client_secret   = ""
  tenant_id       = ""
```
### Start and remove your project:
```
terraform init
terraform plan
terraform apply
terraform destroy
```

```
data_grafana.sh - This script will install everything needed to run grafana in a docker container
```
![image](https://user-images.githubusercontent.com/42977616/210903698-43cbf759-02bb-4647-8b5b-f426478c964d.png)
