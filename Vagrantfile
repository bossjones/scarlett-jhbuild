# -*- mode: ruby -*-
# vi: set ft=ruby :

box_ip = '192.168.33.60'

$script = <<SCRIPT
echo installing base dependencies
dnf upgrade -y
dnf install -y python2 ansible python2-dnf libselinux-python
date > /etc/vagrant_provisioned_at
SCRIPT

$tools_provision = <<SCRIPT
dnf update -y; \
dnf group install "C Development Tools and Libraries" -y; \
dnf install -y wget curl vim \
               glibc-langpack-en.x86_64 \
               redhat-rpm-config htop perf \
               tcpdump nmap lsof strace dstat \
               ngrep iotop socat sysstat procps-ng \
               net-tools file atop ltrace bridge-utils \
               ca-certificates iftop iperf iproute bash \
               bash-completion gettext ncurses hdparm psmisc \
               tree speedtest-cli pv sslscan nmon collectl \
               sos iputils net-tools iperf3 qperf iproute tcpdump \
               tar file python-devel git \
               && curl -Lo /usr/local/bin/xsos bit.ly/xsos-direct && chmod +x /usr/local/bin/xsos && \
               pip install zeroconf netifaces pymdstat influxdb elasticsearch potsdb statsd pystache docker-py \
               pysnmp pika py-cpuinfo bernhard scandir; \
cd /usr/local/bin/; \
wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/memcache-top/memcache-top-v0.6; \
mv memcache-top-v0.6 memcache-top; \
chmod +x memcache-top; \
yum install -y perl perl-Time-HiRes perl-Getopt-Long.noarch; \
cd /usr/local/src/; \
curl -s -q -L 'https://bootstrap.pypa.io/ez_setup.py' > ez_setup.py; \
curl -s -q -L 'https://bootstrap.pypa.io/get-pip.py' > get-pip.py; \
python ez_setup.py; \
python get-pip.py; \
pip install memcache-cli; \
dnf install python3-devel -y; \
cd /usr/local/src/; \
python3 ez_setup.py; \
python3 get-pip.py; \
cd /root; \
[ -d /root/perf-tools ] || git clone https://github.com/brendangregg/perf-tools.git; \
[ -d /root/bcc ] || git clone https://github.com/iovisor/bcc;
SCRIPT

Vagrant.configure('2') do |config|
  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = 'fedora/27-cloud-base'

  config.vm.network 'private_network', ip: box_ip

  # set auto_update to false, if you do NOT want to check the correct
  # additions version when booting this machine
  config.vbguest.auto_update = true

  # do NOT download the iso file from a webserver
  config.vbguest.no_remote = false

  # source: http://stackoverflow.com/questions/17845637/how-to-change-vagrant-default-machine-name
  config.vm.define 'scarlett_jhbuild' do |scarlett_jhbuild|
  end
  config.vm.provider :virtualbox do |vb|
    vb.gui = false
    vb.name = 'scarlett_jhbuild'

    # user modifiable memory/cpu settings
    vb.memory = 6048
    vb.cpus = 4
    vb.customize ['modifyvm', :id, '--cpuexecutioncap', '75']
    vb.customize ['modifyvm', :id, '--chipset', 'ich9']

    # SOURCE: https://github.com/mitre/unfetter-mediawiki-vagrant/blob/master/Vagrantfile
    # SOURCE: https://serverfault.com/questions/74672/why-should-i-enable-io-apic-in-virtualbox?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
    vb.customize ['modifyvm', :id, '--ioapic', 'on'] # Bug 51473
    # Speed up dns resolution in some cases
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
    # Prevent clock drift, see http://stackoverflow.com/a/19492466/323407
    vb.customize ['guestproperty', 'set', :id, '/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold', 10_000]

    vb.customize ['modifyvm', :id, '--usb', 'on']
    vb.customize ['modifyvm', :id, '--audio', 'coreaudio', '--audiocontroller', 'ac97' ]
  end

  public_key = ENV['HOME'] + '/dev/vagrant-box/fedora/keys/vagrant.pub'

  if Vagrant.has_plugin?('vagrant-hostmanager')
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
  end

  # Vagrant can share the source directory using rsync, NFS, or SSHFS (with the vagrant-sshfs
  # plugin). Consult the Vagrant documentation if you do not want to use SSHFS.
  config.vm.synced_folder '.', '/vagrant', disabled: true
  # config.vm.synced_folder ".", "/home/vagrant/devel", type: "sshfs", sshfs_opts_append: "-o nonempty"

  # install sysadmin basics
  # config.vm.provision 'shell', inline: $script
  # config.vm.provision 'shell', inline: $tools_provision

#   config.vm.provision 'ansible' do |ansible|
#     ansible.playbook = 'playbook.yml'
#     ansible.verbose = '-v'
#     # ansible.sudo = true
#     ansible.host_key_checking = false
#     ansible.limit = 'all'
#     ansible.extra_vars = {
#       public_key: public_key
#     }
#   end

  config.vm.hostname = 'scarlett-jhbuild'
  config.vm.boot_timeout = 400

  # network
  config.vm.network 'public_network', bridge: 'en0: Wi-Fi (AirPort)'
  config.vm.network 'forwarded_port', guest: 19_360, host: 1936
  config.vm.network 'forwarded_port', guest: 139, host: 1139
  config.vm.network 'forwarded_port', guest: 8081, host: 8881
  config.vm.network 'forwarded_port', guest: 2376, host: 2376
  config.vm.network 'forwarded_port', guest: 1999, host: 19_999

  # ssh
  config.ssh.username = 'vagrant'
  config.ssh.host = '127.0.0.1'
  config.ssh.guest_port = '2222'
  config.ssh.private_key_path = ENV['HOME'] + '/dev/bossjones/oh-my-fedora27/keys/vagrant_id_rsa'
  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true
  config.ssh.insert_key = false
  config.ssh.keep_alive = 5
end
