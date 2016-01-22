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
  owner "root"
  group "root"
  mode "0644"
  # notifies :restart, resources(:service => "redis")
end


template "etchosts" do
  path "#{node[:mybook][:hosts_file]}"
  source "etchosts.erb"
  owner "root"
  group "root"
  mode "0644"
  # notifies :restart, resources(:service => "redis")
end