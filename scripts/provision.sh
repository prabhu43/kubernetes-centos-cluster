#!/bin/bash

set -e

echo "Disable swap"
swapoff -a
sed -i '/ swap /s/^/#/' /etc/fstab

echo "Disable SELinux"
setenforce 0

echo "Disable Firewall"
systemctl disable firewalld
systemctl stop firewalld

yum update -y
yum install -y lsof net-tools

echo "Install and Start Docker"
yum install -y docker
systemctl enable docker && systemctl start docker

echo "Add Kubernetes repo"
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1  
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

echo "Install and Start Kubernetes"
yum install -y kubelet kubeadm kubectl
systemctl enable kubelet && systemctl start kubelet

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl --system

echo "Update Kubelet Config"
sed -i '2iEnvironment="KUBELET_EXTRA_ARGS=--runtime-cgroups=/systemd/system.slice --kubelet-cgroups=/systemd/system.slice"' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

echo "Restart Kubelet"
systemctl daemon-reload
systemctl restart kubelet

echo "Done!!!"