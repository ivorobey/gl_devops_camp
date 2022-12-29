[iaa1]
Ubuntu1 ansible_host=${ubuntu_ip}

[iaa2]
Ubuntu2 ansible_host=${ubuntu_ip_1}

[iaa3]
Ubuntu3 ansible_host=${ubuntu_ip_2}

[iaas:children]
iaa1
iaa2