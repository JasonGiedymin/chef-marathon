# encoding: UTF-8

case node['platform']
when 'debian', 'ubuntu'
  default['mesos']['package_format'] = 'deb'
else
  default['mesos']['package_format'] = 'rpm'
end

# == compile ==
default['marathon']['source']['dir'] = "#{Chef::Config['file_cache_path']}/marathon"
default['marathon']['source']['repo'] = 'https://github.com/mesosphere/marathon.git'
default['marathon']['source']['branch'] = 'master' # git branch to compile from

# == install ==
default['marathon']['install']['location'] = '/opt/marathon'

# == marathon conf ==
default['marathon']['runtime']['memory_options'] = '-Xmx512m'
default['marathon']['runtime']['lib_path'] = '/usr/local/lib'
default['marathon']['runtime']['marathon_jar'] = '/opt/marathon/marathon.jar'
default['marathon']['runtime']['zookeeper_hosts'] = 'localhost:2181'
default['marathon']['runtime']['master'] = 'zk://localhost:2181/mesos'
