include_recipe "apt"
include_recipe "build-essential"
include_recipe "networking_basic"
include_recipe "git"

include_recipe "apache2"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_rewrite"
include_recipe "apache2::mod_deflate"
include_recipe "apache2::mod_headers"

include_recipe "mysql::server"

include_recipe "vagrant_main::packages"
include_recipe "vagrant_main::custom_php"

# Install mysql gem
gem_package "mysql" do
  action :install
end

ruby_block "Create database + execute grants" do
  block do
    require 'rubygems'
    Gem.clear_paths
    require 'mysql'
    m = Mysql.new("localhost", "root", "")
    m.query("CREATE DATABASE IF NOT EXISTS app CHARACTER SET utf8")
    m.query("grant all on `app`.* to 'root'@'10.0.2.2' identified by ''")
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
