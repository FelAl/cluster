# cookbook_file "/home/vagrant/testblueprint.json" do
#   source "testblueprint.json"
#   owner "vagrant"
#   group "vagrant"
#   action :create
# end

# cookbook_file "/home/vagrant/creationtempl.json" do
#   source "creationtempl.json"
#   owner "vagrant"
#   group "vagrant"
#   action :create
# end

# service "ambari-server" do
#   action :start
# end

# ------------------

http_request "blueprints list" do
  url "http://localhost:8080/api/v1/blueprints"
  headers({'AUTHORIZATION' => "Basic #{
      Base64.encode64('admin:admin')}"
    })
end

log 'message info' do
  message 'This is the message that will be added to the log. INFO'
  level :info
end
log 'message debug' do
  message 'This is the message that will be added to the log. DEBUG'
  level :debug
end

# @my_var = "Hello from outside"

# log 'message @my_var' do
#   # uri = URI.parse("http://localhost:8080/api/v1/blueprints")
#   # http = Net::HTTP.new(uri.host, uri.port)
#   # request = Net::HTTP::Get.new(uri.request_uri)
#   # request.basic_auth("admin", "admin")
#   # response = http.request(request)
#   # result = response.body.include?(('"blueprint_name" : "testblueprint"'))
#   # node.run_state['blueprint'] = result.to_s

#   # message "Blueprint already uploaded:" + result.to_s + " " + node.run_state['blueprint'].to_s

#   # uri = URI.parse("http://localhost:8080/api/v1/clusters")
#   # http = Net::HTTP.new(uri.host, uri.port)
#   # request = Net::HTTP::Get.new(uri.request_uri)
#   # request.basic_auth("admin", "admin")
#   # response = http.request(request)
#   # result = response.body.include?(('"cluster_name" : "test"'))
#   # node.run_state['cluster'] = result.to_s

#   level :info
# end

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

execute "blueprint load" do
  command 'curl  -i -H "X-Requested-By: ambari" --data "@/home/vagrant/testblueprint.json" -u admin:admin -X POST http://fed.ambari.server:8080/api/v1/blueprints/testblueprint'
  retries 6
  retry_delay 10
  not_if node.run_state['blueprint']
end

execute "cluster setup" do
  command 'curl  -i -H "X-Requested-By: ambari" --data "@/home/vagrant/creationtempl.json" -u admin:admin -X POST http://fed.ambari.server:8080/api/v1/clusters/test'
  retries 6
  retry_delay 10
  not_if node.run_state['cluster']
end
