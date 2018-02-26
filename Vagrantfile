# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"
  config.vm.provision :shell, path: "scripts/provision.sh"
  config.ssh.insert_key = false
  config.ssh.forward_agent = true

  config.trigger.after [:up, :resume] do
    info "Adding ssh key..."
    system "ssh-add ~/.vagrant.d/insecure_private_key"
  end    

  config.vm.define "k8master" do |k8master| 
    k8master.vm.hostname = "k8master"
    k8master.vm.network "private_network", ip: "192.168.33.10"
    k8master.vm.network :forwarded_port, guest: 22, host: 2220, id: 'ssh'
    
    k8master.vm.provider "virtualbox" do |vb|  
     # Customize the amount of memory on the VM:
     vb.memory = "8000"
     vb.name = "k8master"
    end
  end

  config.vm.define "k8worker1" do |k8worker1| 
    k8worker1.vm.hostname = "k8worker1"
    k8worker1.vm.network "private_network", ip: "192.168.33.11"
    k8worker1.vm.network :forwarded_port, guest: 22, host: 2221, id: 'ssh'
    
    k8worker1.vm.provider "virtualbox" do |vb|  
     # Customize the amount of memory on the VM:
     vb.memory = "4000"
     vb.name = "k8worker1"
    end
  end

end
