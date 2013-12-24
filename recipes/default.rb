# encoding: UTF-8

include_recipe 'apt::default'
include_recipe 'java'
include_recipe 'maven'
include_recipe 'chef-mesos'

package 'git'

service 'marathon' do
  provider Chef::Provider::Service::Upstart
  supports status: true, start: true, stop: true, restart: true
  action :stop
end

directory node['marathon']['source']['dir'] do
  mode 00644
  action :create
end

directory node['marathon']['install']['location'] do
  mode 00644
  action :create
end

directory 'delete_src' do
  path node['marathon']['source']['dir']
  recursive true
  action :delete
end

template '/etc/init/marathon.conf' do
  source 'marathon.erb'
  mode 0664
  owner 'root'
  group 'root'
  variables(
    memory_options: node['marathon']['runtime']['memory_options'],
    lib_path: node['marathon']['runtime']['lib_path'],
    marathon_jar: node['marathon']['runtime']['marathon_jar'],
    zookeeper_hosts: node['marathon']['runtime']['zookeeper_hosts'],
    master: node['marathon']['runtime']['master']
  )
end

ruby_block 'install_marathon' do
  block do
    target_mask = 'target/marathon*SNAPSHOT-jar-with-dependencies.jar'
    install_location = node['marathon']['install']['location']

    files = Dir[
      "#{node['marathon']['source']['dir']}/#{target_mask}"
    ]
    files.each do |filename|
      FileUtils.chmod 'u=rx,g=rx', filename
      FileUtils.cp(filename, "#{install_location}/marathon.jar")
    end
  end
  action :nothing
  notifies :start, 'service[marathon]'
end

ruby_block 'cleanup_marathon' do
  block do
    files = Dir["#{node[:marathon][:install][:location]}/marathon*.jar"]
    files.each do |filename|
      FileUtils.rm(filename)
    end
  end
  action :nothing
  notifies :run, 'ruby_block[install_marathon]'
end

bash 'compile_marathon' do
  cwd node[:marathon][:source][:dir]
  code <<-EOH
    mvn clean
    mvn compile
    mvn package
  EOH
  action :nothing
  notifies :run, 'ruby_block[cleanup_marathon]'
end

git node[:marathon][:source][:dir] do
  repository node[:marathon][:source][:repo]
  reference node[:marathon][:source][:branch]
  action :sync
  notifies :run, 'bash[compile_marathon]'
end
