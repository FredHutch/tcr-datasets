#
# Cookbook Name:: tcr-datasets
# Recipe:: configure_nginx
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

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
  template 'tcr_datasets.conf.erb'
  variables(
    'server_name' => node['tcr_datasets']['nginx_config']['server_name'],
    'ssl_cert' => node['tcr_datasets']['nginx_config']['ssl_cert'],
    'ssl_cert_key' => node['tcr_datasets']['nginx_config']['ssl_cert_key'],
    'logdir' => node['tcr_datasets']['nginx_config']['logdir'],
    'uri' => "#{node['tcr_datasets']['nginx_config']['url']}:#{node['tcr_datasets']['nginx_config']['port']}"
  )
end
include_recipe 'nginx'
