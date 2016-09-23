
node.default['tcr_datasets']['nginx_config'] = {
  'server_name' => node['fqdn'],
  'ssl_cert' => '/etc/nginx/ssl.cert',
  'ssl_cert_key' => '/etc/nginx/ssl.cert.key',
  'logdir' => '/var/log/tcr_datasets',
  'url' => 'http://localhost',
  'port' => '8080'
}

node.override['nginx']['default_site_enabled'] = false
node.override['nginx']['default']['modules'] = ['socketproxy']
node.override['nginx']['port'] = '80'

node.override['nginx']['socketproxy']['root'] = '/var/www/apps'

node.override['nginx']['socketproxy']['default_app'] = 'tcr_datasets'
node.override['nginx']['socketproxy']['apps'] = {
  'tcr_datasets' => {
    'subdir' => 'tcr_datasets',
    'socket' => {
      'type' => 'tcp',
      'port' => '8443'
    }
  }
}
