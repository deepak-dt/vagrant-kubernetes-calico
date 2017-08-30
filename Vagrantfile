# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
vagrant_config = YAML.load_file("provisioning/virtualbox.conf.yml")

Vagrant.configure("2") do |config|

  config.vm.box = vagrant_config['box']
  
  #if Vagrant.has_plugin?("vagrant-cachier")
  #  # Configure cached packages to be shared between instances of the same base box.
  #  # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
  #  config.cache.scope = :box
  #end

  # Bring up the Devstack controller node on Virtualbox
  config.vm.define "kube_calico_vm" do |kube_calico_vm|
    kube_calico_vm.vm.provision :shell, path: "provisioning/setup-kubernetes-calico.sh"

	config.vm.provider "virtualbox" do |vb|
      # Display the VirtualBox GUI when booting the machine
      vb.gui = true

      # Customize the amount of memory on the VM:
      vb.memory = vagrant_config['kube_calico_vm']['memory']
      vb.cpus = vagrant_config['kube_calico_vm']['cpus']
	  
	  config.vm.network "private_network", ip: "203.0.113.9"
	  #config.vm.network "private_network", ip: "fd80:24e2:f998:72d7::1", netmask: "112"
    end
  end

  config.vm.provision "file", source: "provisioning/calico.yaml", destination: "/home/vagrant/calico.yaml"
  config.vm.synced_folder '.', '/vagrant'

end
