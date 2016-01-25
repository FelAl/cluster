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
  action [:enable, :start]
end

http_request "blueprint upload" do
  action :post
  url "http://localhost:8080/api/v1/blueprints/testblueprint"
  headers({ "AUTHORIZATION" => "Basic #{
      Base64.encode64('admin:admin')}", "X-Requested-By" => "ambari" })
  message ::File.read("/home/vagrant/testblueprint.json")
  not_if 'curl  -u admin:admin http://localhost:8080/api/v1/blueprints | grep "\"blueprint_name\" : \"testblueprint\""'
end

http_request "cluster test setup" do
  action :post
  url "http://localhost:8080/api/v1/clusters/test"
  headers({ "AUTHORIZATION" => "Basic #{
      Base64.encode64('admin:admin')}", "X-Requested-By" => "ambari" })
  message ::File.read("/home/vagrant/creationtempl.json")
  not_if 'curl  -u admin:admin http://localhost:8080/api/v1/clusters | grep "\"cluster_name\" : \"test\""'
end
