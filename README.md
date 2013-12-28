chef-marathon
-------------


[![Build Status](https://travis-ci.org/JasonGiedymin/chef-marathon.png?branch=master)](https://travis-ci.org/JasonGiedymin/chef-marathon)


## Default Attribs

    default['marathon']['source']['repo']      = 'https://github.com/mesosphere/marathon.git'
    default['marathon']['source']['branch']    = 'master'

    # == install ==
    default['marathon']['install']['location'] = '/opt/marathon'

    # == marathon conf ==
    default['marathon']['runtime']['memory_options']  = '-Xmx512m'
    default['marathon']['runtime']['lib_path']        = '/usr/local/lib'
    default['marathon']['runtime']['marathon_jar']    = '/opt/marathon/marathon.jar'
    default['marathon']['runtime']['zookeeper_hosts'] = 'localhost:2181'
    default['marathon']['runtime']['master']          = 'zk://localhost:2181/mesos'
