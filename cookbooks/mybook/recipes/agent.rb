#
# Cookbook Name:: mybook
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

template "agent.init.conf" do
  path "#{node[:mybook][:agent_conf]}"
  source "agent.init.conf.erb"
  owner "vagrant"
  group "vagrant"
  mode "0644"
  notifies :restart, service: "ambari-agent"
end

service "ntpd" do
  action [:enable, :start]
end

service "ambari-agent" do
  action [:enable, :start]
end

remote_file "/home/vagrant/ngrok.zip" do
  source "https://dl.ngrok.com/ngrok_2.0.19_linux_amd64.zip"
  owner "vagrant"
  group "vagrant"
  mode "0755"
  action :create
end

execute "extract ngrok" do
  command "unzip ngrok.zip"
  cwd "/home/vagrant/"
  not_if { File.exist?("/home/vagrant/ngrok") }
end