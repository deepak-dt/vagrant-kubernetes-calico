#!/usr/bin/env bash

# Steps to install and configure devstack
sudo apt-get update -y
#sudo apt-get -y install git vim-gtk python-pip
#sudo pip install git-review tox 

#git config --global user.email "deepak.dt@gmail.com"
#git config --global user.name "Deepak Tiwari"
#git config --global user.editor "vim"

export WORKSPACE=$PWD
export HOST_IP=203.0.113.9
export SERVICE_CIDR=10.96.0.0/24
export CLUSTER_IP=10.96.0.9

#######################################################################################
# Install Dokcer
#######################################################################################
sudo apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual
sudo apt-get update -y
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
	
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get update -y
sudo apt-get -y install docker-ce


#######################################################################################
# Install Kubernetes and related packages
#######################################################################################
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo deb http://apt.kubernetes.io/ kubernetes-xenial main >> /etc/apt/sources.list.d/kubernetes.list
apt-get update -y
apt-get install -y kubelet kubeadm kubectl kubernetes-cni


#######################################################################################
# Fetch the calicoctl binary
#######################################################################################
curl -L --silent https://github.com/projectcalico/calico-containers/releases/download/v1.0.0/calicoctl -o /usr/local/bin/calicoctl
chmod +x /usr/local/bin/calicoctl
export ETCD_ENDPOINTS=http://$CLUSTER_IP:6666

#######################################################################################
# Install Kubernetes and related packages
#######################################################################################
#kubeadm init --apiserver-advertise-address=$HOST_IP --service-cidr=$SERVICE_CIDR
#kubectl taint nodes --all node-role.kubernetes.io/master-

#######################################################################################
# Fetch and apply calico.yaml
#######################################################################################
#kubectl apply -f calico.yaml


#######################################################################################
# Launch nginx pod
#######################################################################################
cat > nginx.yaml <<EOT
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: my-nginx
spec:
  replicas: 2
  template:
    metadata:
      labels:
        run: my-nginx
    spec:
      containers:
      - name: my-nginx
        image: nginx
        ports:
        - containerPort: 80
EOT
#kubectl apply -f nginx.yaml



# Replace git.openstack.org with https://github.com/openstack in "GIT_BASE=${GIT_BASE:-git://git.openstack.org}"
#str_to_rep_old="git\:\/\/git.openstack.org"
#str_to_rep_new="https\:\/\/git.openstack.org"

#sed -n "1h;2,\$H;\${g;s/$str_to_rep_old/$str_to_rep_new/;p}" $WORKSPACE/devstack/stackrc > $WORKSPACE/devstack/stackrc_new
#mv $WORKSPACE/devstack/stackrc_new $WORKSPACE/devstack/stackrc

