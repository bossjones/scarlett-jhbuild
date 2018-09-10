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

    config.vm.hostname = "scarlett-jhbuild"
    aliases = %w(scarlett-jhbuild.home scarlett-jhbuild.localdomain scarlett-jhbuild-alias)

    if Vagrant.has_plugin?('vagrant-hostsupdater')
      config.hostsupdater.aliases = aliases
    elsif Vagrant.has_plugin?('vagrant-hostmanager')
      config.hostmanager.enabled = true
      config.hostmanager.manage_host = true
      config.hostmanager.aliases = aliases
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

    # NOTE: Improving Performance on Low-Memory Linux VMs
    # NOTES: https://www.codero.com/knowledge-base/content/3/389/en/custom-swap-on-linux-virtual-machines.html
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

    # # NOTE: mproving Performance on Low-Memory Linux VMs
    # config.vm.provision 'shell' do |s|
    #   s.inline = <<-SHELL
    #   sed -i "s,# deb-src http://archive.ubuntu.com/ubuntu/ bionic main restricted, deb-src http://archive.ubuntu.com/ubuntu/ bionic main restricted,g" /etc/apt/sources.list; \
    #   sed -i "s,# deb-src http://archive.ubuntu.com/ubuntu/ bionic-updates main restricted,deb-src http://archive.ubuntu.com/ubuntu/ bionic-updates main restricted,g" /etc/apt/sources.list; \
    #   DEBIAN_FRONTEND=noninteractive apt-get update; apt-get install -y \
    #   sudo \
    #   bash-completion \
    #   apt-file \
    #   autoconf \
    #   automake \
    #   gettext \
    #   yelp-tools \
    #   flex \
    #   bison \
    #   build-essential \
    #   ccache \
    #   curl \
    #   dbus \
    #   gir1.2-gtk-3.0 \
    #   git \
    #   gobject-introspection \
    #   lcov \
    #   libbz2-dev \
    #   libcairo2-dev \
    #   libffi-dev \
    #   libgirepository1.0-dev \
    #   libglib2.0-dev \
    #   libgtk-3-0 \
    #   libreadline-dev \
    #   libsqlite3-dev \
    #   libssl-dev \
    #   ninja-build \
    #   python3-pip \
    #   xauth \
    #   pulseaudio-utils \
    #   gstreamer1.0-pulseaudio \
    #   libcanberra-pulse \
    #   libpulse-dev \
    #   libpulse-mainloop-glib0 \
    #   libpulse0 \
    #   xvfb \
    #   vim \
    #  ; \
    #       apt-get update \
    #  ; \
    #   DEBIAN_FRONTEND=noninteractive apt-get install -y gstreamer1.0-plugins* \
    #  ; \
    #   DEBIAN_FRONTEND=noninteractive apt-get install -y libegl1-mesa-dev libxklavier-dev libudisks2-dev libdmapsharing-3.0-dev libplist-dev nettle-dev libgphoto2-dev liblcms2-dev libfuse-dev libsane-dev libxt-dev libical-dev libgbm-dev valgrind libusb-1.0-0-dev libxcb-res0-dev xserver-xorg-input-wacom libstartup-notification0-dev libgexiv2-dev libarchive-dev libgl1-mesa-dev libfwup-dev libgnutls28-dev libpoppler-glib-dev libnma-dev libtag1-dev libusb-1.0-0-dev libndp-dev uuid-dev libgraphviz-dev libbluray-dev libcdio-paranoia-dev libsmbclient-dev libmtp-dev libv4l-dev libnfs-dev libpwquality-dev libxft-dev libsystemd-dev libnss3-dev libseccomp-dev libexiv2-dev check libhunspell-dev libmtdev-dev libanthy-dev libxrandr-dev libxdamage-dev libopus-dev libxi-dev libp11-kit-dev libtasn1-6-dev libwavpack-dev libnl-route-3-dev libcanberra-gtk-dev libxtst-dev libexempi-dev libudev-dev libplymouth-dev libxfixes-dev libunwind-dev libcaribou-dev libpolkit-agent-1-dev libavahi-gobject-dev libpolkit-gobject-1-dev dbus-tests libnl-genl-3-dev libxcb-dri2-0-dev liboauth-dev libpsl-dev libdrm-dev libevdev-dev libnspr4-dev libcanberra-gtk3-dev libexif-dev libvpx-dev libusbredirhost-dev libsndfile1-dev libxkbfile-dev libelf-dev libhangul-dev libxkbcommon-dev libxml2-dev libdotconf-dev libmusicbrainz5-dev libxslt1-dev libraw-dev libdbus-glib-1-dev libegl1-mesa-dev libnl-3-dev libxi-dev libsource-highlight-dev libvirt-dev libxcb-randr0-dev libimobiledevice-dev libgles2-mesa-dev libxkbcommon-x11-dev nettle-dev libxcomposite-dev libflac-dev libxcursor-dev libdvdread-dev libproxy-dev libkyotocabinet-dev libwebkit2gtk-4.0-dev libepoxy-dev flex valac xmlto texinfo xwayland libcups2-dev ruby libgpgme-dev gperf wget cmake sassc argyll intltool desktop-file-utils docbook-utils ragel doxygen yasm cargo libunistring-dev libmpfr-dev libhyphen-dev libkrb5-dev ppp-dev libxinerama-dev libmpc-dev libsasl2-dev libldap2-dev libpam0g-dev libdb5.3-dev libcap-dev libtiff5-dev libmagic-dev libgcrypt20-dev libiw-dev libjpeg-turbo8-dev libyaml-dev libwebp-dev libespeak-dev intltool libxslt1-dev docbook-xml docbook-xsl libgudev-1.0-dev gir1.2-gudev-1.0 libfl-dev fcitx-libs-dev libxcb-xkb-dev doxygen xorg-dev libepoxy-dev libdbus-1-dev libjpeg-dev libtiff-dev desktop-file-utils libwayland-egl1-mesa ragel libxml2-dev libxft-dev xmlto libxtst-dev xutils-dev python-six python-pip \
    #  ; \
    #       rm -rf /var/lib/apt/lists/*
    #   SHELL
    #   s.privileged = true
    # end

    master.vm.provision "ansible" do |ansible|
        ansible.playbook = "site.yml"
        ansible.verbose = "vvvv"
    end
  end
end
