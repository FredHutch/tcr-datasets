#
# Cookbook Name:: tcr-datasets
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#
include_recipe 'nginx'

nginx_site 'tcr-datasets' do
  enable true
  template 'tcr-datasets.conf.erb'
  variables(
    'server_name' => node['tcr-datasets']['server_name'],
    'ssl_cert' => node['tcr-datasets']['ssl_cert'],
    'ssl_cert_key' => node['tcr-datasets']['ssl_cert_key'],
    'logdir' => node['tcr-datasets']['logdir'],
    'uri' => "#{node['tcr-datasets']['url']}:#{node['tcr-datasets']['port']}"
  )
end

