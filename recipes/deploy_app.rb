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

template 'uwsgi configuration' do
  path '/etc/uwsgi/apps-available/tcr_datasets.ini'
  source 'uwsgi/tcr_datasets.ini.erb'
end

link 'enable tcr app' do
  target_file '/etc/uwsgi/apps-enabled/tcr_datasets.ini'
  to '/etc/uwsgi/apps-available/tcr_datasets.ini'
end

directory "#{node['tcr_datasets']['app']['webroot']}/app" do
  owner node['tcr_datasets']['app']['user']
  mode 0755
  action :create
end

service 'uwsgi' do
  action :start
end
