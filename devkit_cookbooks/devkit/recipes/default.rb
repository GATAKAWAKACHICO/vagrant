#
# Cookbook Name:: devkit
# Recipe:: default
#
# Copyright 2014, Masaki Wakatake
#
# All rights reserved - Do Not Redistribute
#

# stop iptables
service "iptables" do
  action [:stop, :disable]
end

# apt-get update
execute "apt-get update" do
  command "apt-get update"
end

# install vim
%w{vim}.each do |pkg|
  package pkg do
    action :install
  end
end

template "minimal_vimrc" do
  path "/home/vagrant/.vimrc"
  source "minimal_vimrc"
  mode 0644
  owner "vagrant"
  group "vagrant"
end

# install wget
%w{wget}.each do |pkg|
  package pkg do
    action :install
  end
end

# install git
%w{git}.each do |pkg|
  package pkg do
    action :install
  end
end

# install unzip
%w{unzip}.each do |pkg|
  package pkg do
    action :install
  end
end

# install php
%w{php5 php5-mysql php5-curl php5-cli php5-fpm php-pear curl imagemagick php5-imagick}.each do |pkg|
  package pkg do
    action :install
  end
end

# install imagemagick
%w{imagemagick libmagickwand-dev}.each do |pkg|
  package pkg do
    action :install
  end
end

# install ruby
execute "install ruby" do
  command <<-EOH
    add-apt-repository -y ppa:brightbox/ruby-ng
    apt-get update
    apt-get -y install ruby2.1
    apt-get -y install ruby2.1-dev
    apt-get -y install g++
    gem install rails --no-ri --no-rdoc
  EOH
end


# install mysql
%w{mysql-server libmysqld-dev libmysqlclient-dev}.each do |pkg|
  package pkg do
    action :install
  end
end

# service configuration
service "mysql" do
  action [:enable, :start]
end

# vundle
vundle_path = "/home/vagrant/.vim/bundle/vundle"
directory vundle_path do
  owner "vagrant"
  group "vagrant"
  recursive true
  mode 0755
  action :create
  not_if { File.exists? vundle_path }
end
execute "vundle (vim) install" do 
  command <<-EOH
    git clone http://github.com/gmarik/vundle.git #{vundle_path}
    chown -R vagrant:vagrant /home/vagrant/.vim
  EOH
  not_if { File.exists? vundle_path + "/README.md" }
end
