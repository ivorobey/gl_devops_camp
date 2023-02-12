### Create a cluster in Kubernetes with kubespray. In order to create a cluster, we used the step-by-step instruction

Create VM in GCP

Config Cluster by instrutction 

```
ansible-playbook -i inventory/mycluster/inventory.ini --private-key /pem/id_rsa -e ansible_user=remote_user -b  cluster.yml
```

![image](https://user-images.githubusercontent.com/42977616/218324269-98bff3d3-5006-41c6-bd88-2a23e62fe4da.png)
```
ssh -i /pathtokey/id_rsa YOUR_VM_IP
```
![image](https://user-images.githubusercontent.com/42977616/218325029-8bd984e9-ecc4-43c1-b5a9-974ce98ad503.png)
