#
# Cookbook Name:: tcr-datasets
# Recipe:: ssh_wrapper
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#

# This deploys the deploy key from an encrypted databag and configures
# an ssh-wrapper for the deploy step.

include_recipe 'chef-vault::default'
deploy_key = chef_vault_item('tcr-datasets', 'deploy_key')

directory '/var/spool/tcr_datasets/.ssh' do
  owner node['tcr_datasets']['app']['user']
  recursive true
  mode '0755'
end

file '/var/spool/tcr_datasets/.ssh/id' do
  owner node['tcr_datasets']['app']['user']
  mode '0600'
  content deploy_key['private_key']
end

file '/var/spool/tcr_datasets/.ssh/id.pub' do
  owner node['tcr_datasets']['app']['user']
  mode '0644'
  content deploy_key['public_key']
end

cookbook_file '/var/spool/tcr_datasets/.ssh/config' do
  owner node['tcr_datasets']['app']['user']
  mode '0644'
  source 'tcr_ssh_config'
end

file '/var/spool/tcr_datasets/.ssh/known_hosts' do
  owner node['tcr_datasets']['app']['user']
  mode '0644'
  action :touch
end

execute 'github known_hosts' do
  command 'ssh-keygen -R github.com ; ssh-keyscan -H github.com >> /var/spool/tcr_datasets/.ssh/known_hosts'
end
