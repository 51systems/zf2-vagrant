Vagrant.require_version ">= 1.7.0"

Vagrant.configure("2") do |config|
      config.vm.box = "chef/ubuntu-14.04"

      if Vagrant.has_plugin? 'vagrant-omnibus'
          # Set Chef version for Omnibus
          config.omnibus.chef_version = :latest
        else
          raise Vagrant::Errors::VagrantError.new,
            "vagrant-omnibus missing, please install the plugin:\n" +
            "vagrant plugin install vagrant-omnibus"
        end

      # Create a forwarded port mapping which allows access to a specific port
      # within the machine from a port on the host machine.
      # Forward http port on 8080, used for connecting web browsers to localhost:8080
      config.vm.network :forwarded_port, guest: 80, host: 8080
      # Forward MySql port on 3306, used for connecting admin-clients to localhost:3306
      config.vm.network :forwarded_port, guest: 3306, host: 3306

      # config.ssh.max_tries = 50
      # config.ssh.timeout   = 300
      config.vm.synced_folder ".", "/vagrant", :id => "vagrant-root",
          :owner => "vagrant",
          :group => "www-data",
          :mount_options => ["dmode=775,fmode=664"]

      # Provider-specific configuration so you can fine-tune VirtualBox for Vagrant.
      # These expose provider-specific options.
      config.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--memory", 1024]
        vb.customize ["modifyvm", :id, "--cpus", 1]
      end

      #This can pin the used chef version if required
      #config.omnibus.chef_version = :latest
      config.vm.provision :chef_zero do |chef|
         chef.cookbooks_path = [ "./cookbooks", "./site-cookbooks" ]
         chef.log_level = :debug


         chef.add_recipe "vagrant_main"
      end
end
