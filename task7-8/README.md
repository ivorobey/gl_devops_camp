I use machine (controller)  a Windows 11  with WSL2

```
terraform init 
terraform plan
terraform apply -var username="your linux user"
```

![image](https://user-images.githubusercontent.com/42977616/214582704-ce0e74bd-d638-4902-ad8e-bb1e55573c8f.png)

ssh -i .ssh/tfkey.pem {username}@{instance_ip}
![image](https://user-images.githubusercontent.com/42977616/214582806-82841a12-090f-4999-923e-df6d08cbd902.png)

