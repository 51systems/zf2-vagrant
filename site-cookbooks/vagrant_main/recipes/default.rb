include_recipe "apt"
include_recipe "build-essential"
include_recipe "git"

include_recipe "apache2"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_rewrite"
include_recipe "apache2::mod_deflate"
include_recipe "apache2::mod_headers"

include_recipe "vagrant_main::packages"
include_recipe "vagrant_main::custom_php"

# Install Mysql
mysql_service "default" do
  port node['mysql']['port']
  version node['mysql']['version']
  initial_root_password node['mysql']['server_root_password']
  action [:create, :start]
end
mysql_client 'default' do
  action :create
end

# Install mysql gem
gem_package "mysql" do
  action :install
end

ruby_block "Create database + execute grants" do
  block do
    require 'rubygems'
    Gem.clear_paths
    require 'mysql'
    m = Mysql.new("127.0.0.1", "root", node['mysql']['server_root_password'])
    m.query("CREATE DATABASE IF NOT EXISTS app CHARACTER SET utf8")
    m.query("grant all on `app`.* to 'root'@'%' identified by '#{Shellwords.escape(node['mysql']['server_root_password'])}'")
    m.reload
  end
end

# Initialize web app
web_app "app" do
    template "app.conf.erb"
    server_name "localhost"
    server_aliases [node['fqdn'], "localhost"]
    docroot "/vagrant/public"
end

# Add site info in /etc/hosts
#bash "hosts" do
#  code "echo 127.0.0.1 #{site["host"]} #{site["aliases"].join(' ')} >> /etc/hosts"
#end

# Disable default site
apache_site "default" do
  enable false
end
