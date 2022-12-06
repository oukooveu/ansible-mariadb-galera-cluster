# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/jammy64"

  config.vm.define "test-box" do |host|
    host.vm.provider "virtualbox" do |vb|
      vb.cpus = 4
      vb.memory = 4096
    end

    host.vm.provision "shell", path: "vagrant-box-converge.sh"
    host.vm.hostname = "test-box"
  end
end
