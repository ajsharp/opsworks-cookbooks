name "haproxy-elb"

recipe 'haproxy-elb', 'Install and configure a HAProxy instance'
recipe 'haproxy-elb::configure', 'reconfigure and restart HAProxy'

attribute 'haproxy/backend',
  :display_name => 'Backend',
  :description => 'List of backend services to load balance',
  :required => true,
  :type => 'array'

# depends 'opsworks_commons'
depends 'haproxy'
