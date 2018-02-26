# kubernetes-centos-cluster
Create a kubernetes multi node cluster with centos virtual machines using vagrant


Prerequisites:
* Vagrant (>= 2.0.2)
* VirtualBox (>= 5.2.2)
* Vagrant triggers plugin: `vagrant plugin install vagrant-triggers`

`$ git clone git@github.com:prabhu43/kubernetes-centos-cluster.git`

`$ cd kubernetes-centos-cluster`

`$ vagrant up`

Setup Kubernetes Master Node

```
$ vagrant ssh k8master

[vagrant@k8master ~]$ sudo su

[root@k8master vagrant]# kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.33.10
```

The above command will setup master node and print the command to be used to join worker nodes with master. For example: kubeadm join --token \<token> 192.168.33.10:6443 --discovery-token-ca-cert-hash \<sha>. Use this command to join the worker with master later.

Set path variable to use kubectl commands: `export KUBECONFIG=/etc/kubernetes/admin.conf`

Flannel Network:
```
[root@k8master vagrant]# curl -O https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

Edit kube-flannel.yml:  Link eth1 as interface for flannel -> command: [ "/opt/bin/flanneld", "--ip-masq", "--kube-subnet-mgr" , "--iface=eth1"]

```
[root@k8master vagrant]# kubectl apply -f kube-flannel.yml

```

Use Master as worker node: `kubectl taint nodes --all node-role.kubernetes.io/master-`


Join worker node to master

```
$ vagrant ssh k8worker1

[vagrant@k8master ~]$ sudo su

[root@k8master vagrant]# kubeadm join --token \<token> 192.168.33.10:6443 --discovery-token-ca-cert-hash \<sha>

```






