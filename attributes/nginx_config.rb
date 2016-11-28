
node.default['tcr_datasets']['nginx_config'] = {
  'server_name' => node['fqdn'],
  'ssl_cert' => '/etc/nginx/ssl.cert',
  'ssl_cert_key' => '/etc/nginx/ssl.cert.key',
  'logdir' => '/var/log/tcr_datasets',
  'url' => 'http://localhost',
  'port' => '8080'
}

node.override['nginx']['default_site_enabled'] = false
