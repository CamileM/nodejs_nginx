#
# Cookbook:: nodejs_nginx
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

apt_update 'update_sources' do
  action :update
end

package 'nginx'

service 'nginx' do
  action [:enable, :start]
end

package 'nodejs'

package 'npm'

service 'npm' do
  action [:enable, :start]
end


# 1 TEMPLATE
template '/etc/nginx/sites-available/proxy.conf' do
  source 'proxy.conf.erb'
  notifies :restart, 'service[nginx]'
end

# 2 CREATE LINK
link '/etc/nginx/sites-enabled/proxy.conf' do
  to '/etc/nginx/sites-available/proxy.conf'
  action :create
  notifies :restart, 'service[nginx]'
end

# 3 DELETE LINK
link '/etc/nginx/sites-enabled/default' do
  action :delete
  notifies :restart, 'service[nginx]'
end
