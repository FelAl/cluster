cookbook_file "/home/vagrant/testblueprint.json" do
  source "testblueprint.json"
  # path "/home/vagrant/testblueprint.json"
  owner "vagrant"
  group "vagrant"
  mode 0755
  action :create
end

cookbook_file "/home/vagrant/creationtempl.json" do
  source "creationtempl.json"
  # source "file:///home/alfe/mkdev/bigdata/cluster/cookbooks/mybook/files/creationtempl.json"
  owner "vagrant"
  group "vagrant"
  mode 0755
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
  message lazy {::File.open("/home/vagrant/testblueprint.json").read }
  not_if 'curl  -u admin:admin http://localhost:8080/api/v1/blueprints | grep "\"blueprint_name\" : \"testblueprint\""'
end

http_request "cluster test setup" do
  action :post
  url "http://localhost:8080/api/v1/clusters/test"
  headers({ "AUTHORIZATION" => "Basic #{
      Base64.encode64('admin:admin')}", "X-Requested-By" => "ambari" })
  message lazy {::File.open("/home/vagrant/creationtempl.json").read }
  not_if 'curl  -u admin:admin http://localhost:8080/api/v1/clusters | grep "\"cluster_name\" : \"test\""'
end
