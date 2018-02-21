#
# Cookbook:: database
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.



#mysql_service 'mysql' do
#  port '3306'
#  version '5.5'
#  initial_root_password '1234567890'
#  action [:create, :start]
#end
#include_recipe 'mysql-multi::default'
selinux_state "SELinux Permissive" do
  action :permissive
end
bash 'disable selinux' do
  code "setenforce 0"
end
include_recipe 'yum-mysql-community::mysql56'
if node[:tags].include? "mysql_master"
  sqlpasses = data_bag_item('mysql','app_mysql')
  sqlpass="#{sqlpasses['app_user_pass']}"
  include_recipe 'mysql-multi::default'
  include_recipe 'mysql-multi::mysql_master'
  template '/tmp/sql' do
    source 'mysql.erb'
    variables(userpass: sqlpass)
    action :create
  end
  bash 'create database' do
    code "mysql < /tmp/sql"
  end
  file '/tmp/sql' do
    action: delete
  end
end
if node[:tags].include? "mysql_slave"
  include_recipe 'mysql-multi::default'
  include_recipe 'mysql-multi::mysql_slave'
end