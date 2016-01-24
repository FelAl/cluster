# template "etchosts" do
#   path "#{node[:mybook][:hosts_file]}"
#   source "etchosts.erb"
#   owner "root"
#   group "root"
#   mode "0644"
# end

cookbook_file "/home/vagrant/testblueprint.json" do
  source "testblueprint.json"
  owner "vagrant"
  group "vagrant"
  action :create
end

cookbook_file "/home/vagrant/creationtempl.json" do
  source "creationtempl.json"
  owner "vagrant"
  group "vagrant"
  action :create
end

service "ambari-server" do
  action :start
end

execute "blueprint load" do
  command 'curl  -i -H "X-Requested-By: ambari" --data "@/home/vagrant/testblueprint.json" -u admin:admin -X POST http://fed.ambari.server:8080/api/v1/blueprints/testblueprint'
  retries 6
  retry_delay 10
end

execute "cluster setup" do
  command 'curl  -i -H "X-Requested-By: ambari" --data "@/home/vagrant/creationtempl.json" -u admin:admin -X POST http://fed.ambari.server:8080/api/v1/clusters/test'
  retries 6
  retry_delay 10
end
