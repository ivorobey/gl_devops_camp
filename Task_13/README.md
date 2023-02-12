


Docker
Note: before run commands you must install Docker !
sudo docker run --rm -it -v ~/kubespray:/mnt/kubespray  -v ~/.ssh:/pem  quay.io/kubespray/kubespray:v2.20.0 bash
Now you need to go to the kubespray directory and run the playbook(you need to enter your user in this command):

ansible-playbook -i inventory/mycluster/inventory.ini --private-key /pem/id_rsa -e ansible_user=remote_user -b cluster.yml

![image](https://user-images.githubusercontent.com/42977616/218324269-98bff3d3-5006-41c6-bd88-2a23e62fe4da.png)
