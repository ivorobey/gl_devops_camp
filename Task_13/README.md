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

Install Ingress-controller

```
kubectl apply -f nginx-ctl.yaml
kubectl apple -f path_provisioner.yml
```
![image](https://user-images.githubusercontent.com/42977616/218326198-b257a302-53ca-48ca-ae7e-1d2926b2ec33.png)

Prepare domain name (free resource https://dynv6.com/ )

![image](https://user-images.githubusercontent.com/42977616/218327678-003907bf-111a-4485-a8e7-b713bc7330b1.png)

Configure cert-manager (https://cert-manager.io/) with Letsencrypt.
```
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.yaml

kubectl apply -f letsencript.yaml
```

Prepare Nginx deployment:
Deployment
Service
Ingress (which will be connected to ClusterIssuer and use the letsencrypt certificate)

```
kubectl apply -f deployment.yaml
```