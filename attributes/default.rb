case node[:platform]
  when 'debian','ubuntu'
    default['mesos']['package_format'] = 'deb'
  else
    default['mesos']['package_format'] = 'rpm'
end

# == compile ==
default['mesos']['source']['dir']            = "#{Chef::Config[:file_cache_path]}/marathon" # temporary dir to unpack/compile
default['mesos']['source']['repo']           = 'https://github.com/mesosphere/marathon.git'
default['mesos']['source']['branch']         = 'master' # git branch to compile from
