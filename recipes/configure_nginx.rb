#
# Cookbook Name:: tcr-datasets
# Recipe:: configure_nginx
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Something is broken in trusty- install of the package does
# not create this directory.

include_recipe 'nginx::default'

directory '/var/www' do
  mode 0755
  owner 'root'
  only_if { node['lsb']['codename'] == 'trusty' }
end

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

service 'nginx' do
  action :nothing
end

template '/etc/nginx/sites-available/tcr_datasets' do
  source 'nginx/tcr_datasets.conf.erb'
  mode 0755
  owner 'root'
  group 'root'
  variables(
    'server_name' => node['tcr_datasets']['nginx_config']['server_name'],
    'ssl_cert' => node['tcr_datasets']['nginx_config']['ssl_cert'],
    'ssl_cert_key' => node['tcr_datasets']['nginx_config']['ssl_cert_key'],
    'logdir' => node['tcr_datasets']['nginx_config']['logdir'],
    'uri' => node['tcr_datasets']['nginx_config']['url'] + ':' + \
             node['tcr_datasets']['nginx_config']['port']
  )
  notifies :restart, 'service[nginx]', :delayed
end

nginx_site 'tcr_datasets' do
  enable true
  timing :delayed
end
