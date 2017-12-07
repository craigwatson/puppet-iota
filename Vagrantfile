Vagrant.require_version ">= 1.6.5"

# ===========================
# VARIABLES + BOX DEFINITIONS
# ===========================

SSH_BASE_PORT  = 2610
PUPPET_VERSION = "4.10.6"

BOXES = [
  { name: "debian8",  box: "debian/jessie64", version: "8.9.0" },
  { name: "ubuntu16", box: "ubuntu/xenial64", version: "20171201.0.0" },
  { name: "centos7",  box: "centos/7", version: "1710.01" }
]

MODULES = [
  # Module dependencies
  { name: "puppet-archive", version: "2.2.0" },
  { name: "puppetlabs-java", version: "2.3.0" },
  { name: "puppetlabs-stdlib" },
  # Test dependencies
  { "name": "stahnma-epel" }
]

# ==============
# VAGRANT CONFIG
# ==============

unless Vagrant.has_plugin?("vagrant-puppet-install")
  raise 'vagrant-puppet-install is not installed!'
end

Vagrant.configure("2") do |config|

  config.puppet_install.puppet_version = PUPPET_VERSION

  # Handle Puppet 3 and 4/5 paths
  if PUPPET_VERSION.start_with?('3')
    puppet_bin_path = '/usr/bin/puppet'
    module_path = '/etc/puppet/modules'
  else
    puppet_bin_path = '/opt/puppetlabs/bin/puppet'
    module_path = '/etc/puppetlabs/code/environments/production/modules'
  end

  # = Actually do some work
  BOXES.each_with_index do |definition,idx|

    name = definition[:name]
    ip = 254 - idx

    config.vm.define name, autostart: false do |c|

      # == Basic box setup
      c.vm.box         = definition[:box]
      c.vm.box_version = definition[:version] unless definition[:version].nil?
      c.vm.hostname    = "iota-vagrant-#{name}"
      c.vm.network :private_network, ip: "10.0.254.#{ip}"

      # == Shared folder
      if Vagrant::Util::Platform.darwin?
        config.vm.synced_folder ".", "/vagrant", nfs: true
        c.nfs.map_uid = Process.uid
        c.nfs.map_gid = Process.gid
      else
        c.vm.synced_folder ".", "/vagrant", type: "nfs"
      end

      # == Disable vagrant's default SSH port, then configure our override
      new_ssh_port = SSH_BASE_PORT + idx
      c.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", disabled: "true"
      c.ssh.port = new_ssh_port
      c.vm.network :forwarded_port, guest: 22, host: new_ssh_port

      # == Set resources if configured
      c.vm.provider "virtualbox" do |v|
        v.name = "puppet-iota-vagrant-#{name}"
        v.memory = definition[:memory] unless definition[:memory].nil?
        v.cpus = definition[:cpus] unless definition[:cpus].nil?
      end

      # == Install git ... with Puppet!
      c.vm.provision :shell, :inline => "#{puppet_bin_path} resource package git ensure=present"

      # == Install modules
      MODULES.each do |mod|
        if mod[:git].nil?
          if mod[:version].nil?
            mod_version = ''
          else
            mod_version = " --version #{mod[:version]}"
          end
          c.vm.provision :shell, :inline => "#{puppet_bin_path} module install #{mod[:name]}#{mod_version}"
        else
          mod_name = mod[:name].split('-').last
          c.vm.provision :shell, :inline => "if [ ! -d #{module_path}/#{mod_name} ]; then git clone #{mod[:git]} #{module_path}/#{mod_name}; fi"
        end
      end
      c.vm.provision :shell, :inline => "if [ ! -L #{module_path}/iota ]; then ln -s /vagrant #{module_path}/iota; fi"

      # == Finally, run Puppet!
      c.vm.provision :shell, :inline => "STDLIB_LOG_DEPRECATIONS=false #{puppet_bin_path} apply --verbose --show_diff /vagrant/examples/init.pp"
    end
  end
end
