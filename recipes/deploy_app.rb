#
# Cookbook Name:: tcr-datasets
# Recipe:: deploy_app
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

deploy_revision 'tcr_datasets' do
  deploy_to node['tcr_datasets']['app']['webroot']
  repository node['tcr_datasets']['repo']['url']
  user 'tcr'
  symlink_before_migrate.clear
  purge_before_symlink.clear
  create_dirs_before_symlink.clear
  symlinks.clear
end
