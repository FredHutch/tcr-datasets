#
# Cookbook Name:: tcr-datasets
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#

# This deploys the deploy key from an encrypted databag and configures
# an ssh-wrapper for the deploy step.

include_recipe 'chef-vault::default'
deploy_key = chef_vault_item('tcr-datasets', 'deploy_key')

directory '/tmp/tcr-datasets/.ssh' do
  owner 'root'
  recursive true
end

file '/tmp/tcr-datasets/.ssh/id' do
  owner 'root'
  mode '0600'
  content deploy_key['private_key']
end

file '/tmp/tcr-datasets/ssh_wrap.sh' do
  owner 'root'
  mode '0755'
  content "#!/usr/bin/env bash\n"\
          'ssh -o "StrictHostKeyChecking=no" '\
          '-i "/tmp/tcr-datasets/.ssh/id" $1'
end


