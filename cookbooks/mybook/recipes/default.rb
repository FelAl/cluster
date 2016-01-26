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
  notifies :restart, service: "ambari-agent"
end

service "ntpd" do
  action [:enable, :start]
end

service "ambari-agent" do
  action [:enable, :start]
end