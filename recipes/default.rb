#
# Cookbook Name:: tcr-datasets
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#

include_recipe 'apt::default'

user 'tcr' do
  comment 'tcr datasets application user'
  shell '/bin/bash'
  home '/var/spool/tcr_datasets'
  manage_home true
end

package 'git'

include_recipe 'tcr-datasets::ssh'
include_recipe 'tcr-datasets::deploy_app'
include_recipe 'tcr-datasets::configure_nginx'
