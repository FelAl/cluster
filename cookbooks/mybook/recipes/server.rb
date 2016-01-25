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
  action :enable, :start
end

ruby_block "http requests" do
  uri = URI.parse("http://localhost:8080/api/v1/blueprints")
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri)
  request.basic_auth("admin", "admin")
  response = http.request(request)
  result = response.body.include?(('"blueprint_name" : "testblueprint"'))
  node.run_state["blueprint"] = result.to_s

  uri = URI.parse("http://localhost:8080/api/v1/clusters")
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri)
  request.basic_auth("admin", "admin")
  response = http.request(request)
  result = response.body.include?(('"cluster_name" : "test"'))
  node.run_state["cluster"] = result.to_s

  action :nothing
end

http_request "blueprint upload" do
  action :post
  url "http://localhost:8080/api/v1/blueprints/testblueprint"
  headers({ "AUTHORIZATION" => "Basic #{
      Base64.encode64('admin:admin')}", "X-Requested-By" => "ambari" })
  message ::File.read("/home/vagrant/testblueprint.json")
  not_if node.run_state["blueprint"]
end

http_request "cluster test setup" do
  action :post
  url "http://localhost:8080/api/v1/clusters/test"
  headers({ "AUTHORIZATION" => "Basic #{
      Base64.encode64('admin:admin')}", "X-Requested-By" => "ambari" })
  message ::File.read("/home/vagrant/creationtempl.json")
  not_if node.run_state["cluster"]
end
