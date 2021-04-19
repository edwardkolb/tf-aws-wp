Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  config.vm.define "jenkins" do |jenk|
    jenk.vm.hostname = "jenkins"
    jenk.vm.box_check_update = false
    jenk.vm.network "public_network", ip: "192.168.100.10"
    if Vagrant.has_plugin?("vagrant-timezone")
      jenk.timezone.value = "Europe/Minsk"
      jenk.vm.provider "virtualbox" do |vb|
       vb.memory = "2048"
       vb.name = "Jenkins"
       end
    end
  # Config VM provisioning by Ansible
    jenk.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "playbook2.yml"
    end
  end

  config.vm.define "web" do |web|
    web.vm.hostname = "web"
    web.vm.box_check_update = false
    web.vm.network "public_network", ip: "192.168.100.20"
    if Vagrant.has_plugin?("vagrant-timezone")
      web.timezone.value = "Europe/Minsk"
      web.vm.provider "virtualbox" do |vb|
       vb.memory = "2048"
       vb.name = "Web-server"
       end
    end
  # Config VM provisioning by Ansible
    web.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "playbook.yml"
    end
  end
end



