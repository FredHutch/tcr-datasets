#
# Cookbook Name:: tcr-datasets
# Recipe:: configure_nginx
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Something is broken in trusty- install of the package does
# not create this directory.
directory '/var/www' do
  mode 0755
  owner 'root'
  only_if { node['lsb']['codename'] == 'trusty' }
end

# the default recipe tries to start the process.  If the configuration
# is broken it won't start, but neither will it run the remaing recipe to
# possibly fix the config.  We'll have to do this manually downstream
# via notify.
#
# Meanwhile, override the action in the resource collection and watch it
# break when we get a 3.x version of the nginx cookbook.
include_recipe 'nginx'
r = resources(service: 'nginx')
r.action 'enable'

include_recipe 'chef-vault::default'

# Load & deploy certificates from vault

certificate = chef_vault_item('tcr-datasets', 'certificate')
cert = certificate['certificate']
key = certificate['key']

file node['tcr_datasets']['nginx_config']['ssl_cert'] do
  mode 0600
  owner 'root'
  content cert
end

file node['tcr_datasets']['nginx_config']['ssl_cert_key'] do
  mode 0600
  owner 'root'
  content key
end

directory node['tcr_datasets']['nginx_config']['logdir'] do
  mode 0755
  owner 'root'
end

nginx_site 'tcr_datasets' do
  enable true
  template 'nginx/tcr_datasets.conf.erb'
  variables(
    'server_name' => node['tcr_datasets']['nginx_config']['server_name'],
    'ssl_cert' => node['tcr_datasets']['nginx_config']['ssl_cert'],
    'ssl_cert_key' => node['tcr_datasets']['nginx_config']['ssl_cert_key'],
    'logdir' => node['tcr_datasets']['nginx_config']['logdir'],
    'uri' => node['tcr_datasets']['nginx_config']['url'] + ':' + \
             node['tcr_datasets']['nginx_config']['port']
  )
  notfies :reload, 'service[nginx]', :delayed
end

service 'nginx' do
  action :start
end
