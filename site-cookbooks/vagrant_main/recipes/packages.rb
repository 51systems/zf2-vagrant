include_recipe "apt"

# Install packages
%w{ debconf vim screen tmux mc subversion curl make g++ libsqlite3-dev graphviz libxml2-utils lynx links}.each do |a_package|
  package a_package
end