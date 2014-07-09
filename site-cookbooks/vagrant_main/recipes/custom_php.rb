include_recipe "apt"
require_recipe "php"
require_recipe "php::module_mysql"
require_recipe "php::module_apc"
require_recipe "php::module_memcache"
require_recipe "php::module_curl"

#using APT
package "php-pear" do
  action :install
end

# PHP5-Intl needed by ZF2
package "php5-intl" do
  action :install
end

#Install Mcrypt for doctrine encryption (used by some projects)
package "php5-mcrypt" do
  action :install
end

# Using PEAR installer

execute "PEAR: upgrade all packages" do
  command "pear upgrade-all"
end

# Install Xdebug
php_pear "xdebug" do
  action :install
end
template "#{node['php']['ext_conf_dir']}/xdebug.ini" do
  source "xdebug.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
  notifies :restart, resources("service[apache2]"), :delayed
end

# Install Webgrind
git "/var/www/webgrind" do
  repository 'git://github.com/jokkedk/webgrind.git'
  reference "master"
  action :sync
end
template "#{node[:apache][:dir]}/conf.d/webgrind.conf" do
  source "webgrind.conf.erb"
  owner "root"
  group "root"
  mode 0644
  action :create
  notifies :restart, resources("service[apache2]"), :delayed
end
template "/var/www/webgrind/config.php" do
  source "webgrind.config.php.erb"
  owner "root"
  group "root"
  mode 0644
  action :create
end

# Install php-xsl
package "php5-xsl" do
  action :install
end


# Install ruby gems
%w{ rdoc rake mailcatcher }.each do |a_gem|
  gem_package a_gem
end

# Setup MailCatcher
bash "mailcatcher" do
  code "mailcatcher --http-ip 0.0.0.0 --smtp-port 25"
  not_if "ps ax | grep -v grep | grep mailcatcher";
end
template "#{node['php']['ext_conf_dir']}/mailcatcher.ini" do
  source "mailcatcher.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
  notifies :restart, resources("service[apache2]"), :delayed
end
cookbook_file "/etc/rc.local" do
  source "rc.local"
  owner "root"
  group "root"
  mode "0755"
  action :create
end

# Fixing deprecated php comments style in ini files
bash "deploy" do
  code "sudo perl -pi -e 's/(\s*)#/$1;/' /etc/php5/cli/conf.d/*ini"
  notifies :restart, resources("service[apache2]"), :delayed
end