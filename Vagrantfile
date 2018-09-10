# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  # set auto_update to false, if you do NOT want to check the correct
  # additions version when booting this machine
  config.vbguest.auto_update = true

  # do NOT download the iso file from a webserver
  config.vbguest.no_remote = false

  config.vm.define "scarlett-jhbuild" do |master|
    # Every Vagrant development environment requires a box. You can search for
    # boxes at https://atlas.hashicorp.com/search.
    #master.vm.box = "ubuntu/trusty64"
    # For Xenial
    master.vm.box = "ubuntu/bionic64"
    # On Centos the interfaces are not eth0 ... change the playbooks!
    # master.vm.box = "bento/centos-7.5"

    # https://nmrony.info/change-disk-size-of-a-vagrant-box/
    config.disksize.size = '20GB'

    # Disable automatic box update checking. If you disable this, then
    # boxes will only be checked for updates when the user runs
    # `vagrant box outdated`. This is not recommended.
    # master.vm.box_check_update = false

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine. In the example below,
    # accessing "localhost:8080" will access port 80 on the guest machine.
    # DNSMASQ
    master.vm.network "forwarded_port", guest: 53, host: 5300
    # NETDATA
    master.vm.network "forwarded_port", guest: 19999, host: 29999

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    master.vm.network "private_network", ip: "10.0.0.10"

    # Create a public network, which generally matched to bridged network.
    # Bridged networks make the machine appear as another physical device on
    # your network.
    # master.vm.network "public_network"

    # source: http://stackoverflow.com/questions/17845637/how-to-change-vagrant-default-machine-name
    config.vm.provider :virtualbox do |vb|
      vb.gui = false
      vb.name = 'scarlett-jhbuild'

      # user modifiable memory/cpu settings
      vb.memory = 2048
      vb.cpus = 2
      vb.customize ['modifyvm', :id, '--cpuexecutioncap', '75']
      vb.customize ['modifyvm', :id, '--chipset', 'ich9']

      # SOURCE: https://datasift.github.io/storyplayer/v2/tips/vagrant/speed-up-virtualbox.html
      # change the network card hardware for better performance
      # vb.customize ["modifyvm", :id, "--nictype1", "virtio" ]
      # vb.customize ["modifyvm", :id, "--nictype2", "virtio" ]

      # SOURCE: https://github.com/mitre/unfetter-mediawiki-vagrant/blob/master/Vagrantfile
      # SOURCE: https://serverfault.com/questions/74672/why-should-i-enable-io-apic-in-virtualbox?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
      vb.customize ['modifyvm', :id, '--ioapic', 'on'] # Bug 51473
      # Speed up dns resolution in some cases
      # suggested fix for slow network performance
      # see https://github.com/mitchellh/vagrant/issues/1807
      vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
      vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
      # Prevent clock drift, see http://stackoverflow.com/a/19492466/323407
      vb.customize ['guestproperty', 'set', :id, '/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold', 10_000]

      vb.customize ['modifyvm', :id, '--usb', 'on']
      vb.customize ['modifyvm', :id, '--audio', 'coreaudio', '--audiocontroller', 'ac97' ]

      # MAYBE ENBALE THIS?
      # ------------------------------------------------
      # # SOURCE: https://github.com/mitre/unfetter-mediawiki-vagrant/blob/master/Vagrantfile
      # # SOURCE: https://serverfault.com/questions/74672/why-should-i-enable-io-apic-in-virtualbox?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
      # vb.customize ['modifyvm', :id, '--ioapic', 'on'] # Bug 51473
      # # Speed up dns resolution in some cases
      # vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
      # vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
      # # Prevent clock drift, see http://stackoverflow.com/a/19492466/323407
      # vb.customize ['guestproperty', 'set', :id, '/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold', 10_000]
      # vb.customize ['modifyvm', :id, '--usb', 'on']
      # vb.customize ['modifyvm', :id, '--audio', 'coreaudio', '--audiocontroller', 'ac97' ]
      # ------------------------------------------------
    end

    if Vagrant.has_plugin?('vagrant-hostmanager')
      config.hostmanager.enabled = true
      config.hostmanager.manage_host = true
    end

    # Vagrant can share the source directory using rsync, NFS, or SSHFS (with the vagrant-sshfs
    # plugin). Consult the Vagrant documentation if you do not want to use SSHFS.
    config.vm.synced_folder '.', '/vagrant', disabled: true
    # Share an additional folder to the guest VM. The first argument is
    # the path on the host to the actual folder. The second argument is
    # the path on the guest to mount the folder. And the optional third
    # argument is a set of non-required options.
    # master.vm.synced_folder "../data", "/vagrant_data"

    # Provider-specific configuration so you can fine-tune various
    # backing providers for Vagrant. These expose provider-specific options.
    #
    #master.vm.provider "virtualbox" do |vb|
    #  # Customize the amount of memory on the VM:
    #  vb.memory = "2048"
    #end

    # Enable provisioning with a shell script. Additional provisioners such as
    # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
    # documentation for more information about their specific syntax and use.
    master.vm.provision "shell", inline: <<-SHELL
        sudo apt-get update && sudo apt-get install python htop ncdu -y
    SHELL

    # config.vm.provision 'shell', inline: <<-SHELL
    #     apt-get update
    #     apt-get install -y \
    #       apt-transport-https \
    #       ca-certificates \
    #       curl \
    #       python3-pip \
    #       software-properties-common
    #     pip3 install virtualenv
    #     curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    #     add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    #     apt-get update
    #     apt-get install -y docker-ce
    #     usermod --groups docker --append vagrant
    #     echo vm.max_map_count=262144 > /etc/sysctl.d/vm_max_map_count.conf
    #     sysctl --system
    #     grep -qF 'vagrant - nofile 65536' /etc/security/limits.conf || echo 'vagrant - nofile 65536' >> /etc/security/limits.conf
    # SHELL

# end

    config.vm.provision 'shell' do |s|
      s.inline = <<-SHELL
        echo vm.max_map_count=262144 > /etc/sysctl.d/vm_max_map_count.conf
        sysctl --system
        grep -qF 'vagrant - nofile 65536' /etc/security/limits.conf || echo 'vagrant - nofile 65536' >> /etc/security/limits.conf
        grep -qF 'root - nofile 65536' /etc/security/limits.conf || echo 'root - nofile 65536' >> /etc/security/limits.conf
      SHELL
      s.privileged = true
    end

    # NOTE: mproving Performance on Low-Memory Linux VMs
    config.vm.provision 'shell' do |s|
      s.inline = <<-SHELL
      # size of swapfile in megabytes
      swapsize=8000

      # does the swap file already exist?
      grep -q "swapfile" /etc/fstab

      # if not then create it
      if [ $? -ne 0 ]; then
        echo 'swapfile not found. Adding swapfile.'
        fallocate -l ${swapsize}M /swapfile
        chmod 600 /swapfile
        mkswap /swapfile
        swapon /swapfile
        echo '/swapfile none swap defaults 0 0' >> /etc/fstab
      else
        echo 'swapfile found. No changes made.'
      fi

      # output results to terminal
      df -h
      cat /proc/swaps
      cat /proc/meminfo | grep Swap

      # https://www.codero.com/knowledge-base/content/3/388/en/improving-performance-on-low_memory-linux-vms.html
      echo vm.swappiness = 10 >> /etc/sysctl.d/30-vm-swappiness.conf
      echo vm.vfs_cache_pressure = 50 >> /etc/sysctl.d/30-vm-vfs_cache_pressure.conf
      sysctl -p
      SHELL
      s.privileged = true
    end

    # SOURCE: https://peteris.rocks/blog/vagrantfile-for-linux/
    # use local ubuntu mirror
    # config.vm.provision :shell, inline: "sed -i 's/archive.ubuntu.com/lv.archive.ubuntu.com/g' /etc/apt/sources.list"
    # # add swap
    # config.vm.provision :shell, inline: "fallocate -l 4G /swapfile && chmod 0600 /swapfile && mkswap /swapfile && swapon /swapfile && echo '/swapfile none swap sw 0 0' >> /etc/fstab"
    # config.vm.provision :shell, inline: "echo vm.swappiness = 10 >> /etc/sysctl.conf && echo vm.vfs_cache_pressure = 50 >> /etc/sysctl.conf && sysctl -p"
    # # build tools
    # config.vm.provision :shell, inline: "apt-get update"
    # config.vm.provision :shell, inline: "apt-get install build-essential libboost-all-dev -y"
    # config.vm.provision :shell, inline: "wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key | apt-key add -"
    # config.vm.provision :shell, inline: "apt-get install clang-3.4 -y"

    master.vm.provision "ansible" do |ansible|
        ansible.playbook = "site.yml"
        ansible.verbose = "vvvv"
    end
  end
end
