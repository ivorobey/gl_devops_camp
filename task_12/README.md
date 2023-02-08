Task:
```

1.Get information about your worker node and save it in some file

2.Create a new namespace (all resources below will create in this namespace)

3.Prepare deployment.yaml file which will create a Deployment with 3 pods of Nginx or Apache and service for access to these pods via ClusterIP and NodePort. 
Show the status of deployment, pods and services. Describe all resources which you will create and logs from pods

4.Prepare two job yaml files:
One gets content via curl from an internal port (ClusterIP)
Second, get content via curl from an external port (NodePort)

5.Prepare Cronjob.yaml file which will test the connection to Nginx or Apache service every 3 minutes.

```

### 2
```
kubectl create ns globallogic
namespace/globallogic created
kubectl get ns
NAME               STATUS   AGE
calico-apiserver   Active   2d15h
calico-system      Active   2d15h
default            Active   2d15h
globallogic        Active   5s
kube-node-lease    Active   2d15h
kube-public        Active   2d15h
kube-system        Active   2d15h
tigera-operator    Active   2d15h
```

### 3

```
kubectl apply -f deployment.yaml -n globallogic
deployment.apps/nginx-deployment created
service/nginx-cluster-ip created
service/nginx-node-port created

kubectl describe deployment nginx-deployment -n globallogic
Name:                   nginx-deployment
Namespace:              globallogic
CreationTimestamp:      Wed, 08 Feb 2023 13:17:37 +0000
Labels:                 app=nginx
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=nginx
Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=nginx
  Containers:
   nginx:
    Image:        nginx:latest
    Port:         80/TCP
    Host Port:    0/TCP
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   nginx-deployment-6b7f675859 (3/3 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  91s   deployment-controller  Scaled up replica set nginx-deployment-6b7f675859 to 3
```

### 4
```
kubectl get svc -n globallogic
NAME               TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
nginx-cluster-ip   ClusterIP   10.107.233.173   <none>        80/TCP         32s
nginx-node-port    NodePort    10.101.42.28     <none>        80:31000/TCP   32s

kubectl apply -f job_clusterip.yaml -n globallogic
kubectl apply -f job_nodeport.yaml -n globallogic

kubectl logs curl-clusterip-job-wffbd -n globallogic
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
100   615  100   615    0     0   403k      0 --:--:-- --:--:-- --:--:--  600k

```

### 5
```
kubectl describe cronjobs cronjob-nginx -n globallogic
Name:                          cronjob-nginx
Namespace:                     globallogic
Labels:                        <none>
Annotations:                   <none>
Schedule:                      */3 * * * *
Concurrency Policy:            Allow
Suspend:                       False
Successful Job History Limit:  3
Failed Job History Limit:      1
Starting Deadline Seconds:     <unset>
Selector:                      <unset>
Parallelism:                   <unset>
Completions:                   <unset>
Pod Template:
  Labels:  <none>
  Containers:
   cronjob-test-connection:
    Image:      curlimages/curl:latest
    Port:       <none>
    Host Port:  <none>
    Command:
      /bin/sh
      -c
      date;curl http://10.107.233.173/;
    Environment:     <none>
    Mounts:          <none>
  Volumes:           <none>
Last Schedule Time:  Wed, 08 Feb 2023 14:12:00 +0000
Active Jobs:         <none>
Events:
  Type    Reason            Age                  From                Message
  ----    ------            ----                 ----                -------
  Normal  SuccessfulCreate  13m                  cronjob-controller  Created job cronjob-nginx-27931080
  Normal  SawCompletedJob   13m                  cronjob-controller  Saw completed job: cronjob-nginx-27931080, status: Complete
  Normal  SuccessfulCreate  10m                  cronjob-controller  Created job cronjob-nginx-27931083
  Normal  SawCompletedJob   10m                  cronjob-controller  Saw completed job: cronjob-nginx-27931083, status: Complete
  Normal  SuccessfulCreate  7m5s                 cronjob-controller  Created job cronjob-nginx-27931086
  Normal  SawCompletedJob   7m1s                 cronjob-controller  Saw completed job: cronjob-nginx-27931086, status: Complete
  Normal  SuccessfulCreate  4m5s                 cronjob-controller  Created job cronjob-nginx-27931089
  Normal  SawCompletedJob   4m2s (x2 over 4m2s)  cronjob-controller  Saw completed job: cronjob-nginx-27931089, status: Complete
  Normal  SuccessfulDelete  4m2s                 cronjob-controller  Deleted job cronjob-nginx-27931080
  Normal  SuccessfulCreate  65s                  cronjob-controller  Created job cronjob-nginx-27931092
  Normal  SawCompletedJob   61s                  cronjob-controller  Saw completed job: cronjob-nginx-27931092, status: Complete
  Normal  SuccessfulDelete  61s                  cronjob-controller  Deleted job cronjob-nginx-27931083
```
