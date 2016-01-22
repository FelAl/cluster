template "etchosts" do
  path "#{node[:mybook][:hosts_file]}"
  source "etchosts.erb"
  owner "root"
  group "root"
  mode "0644"
end