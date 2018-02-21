# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html

property :homepage, String, default: '<h1>Hello world</h1>'
property :usertext, String, default: ''

action :create do
  selinux_state "SELinux Permissive" do
    action :permissive
  end
  bash 'disable selinux' do
    code "setenforce 0"
  end
  package 'epel-release' do
    action :install
  end
  package 'nginx' do
    action :install
  end
  package 'php' do
    action :install
  end
  package 'php-mysql' do
    action :install
  end
  package 'php-fpm' do
    action
  end
  append_if_no_line "edit php.ini" do
    path "/etc/php.ini"
    line "cgi.fix_pathinfo=0"
  end
  replace_or_add "add socket" do
    path "/etc/php-fpm.d/www.conf"
    pattern "listen = 127.0.0.1:9000"
    line "listen = /var/run/php-fpm/php-fpm.sock"
  end
  replace_or_add "add socket" do
    path "/etc/php-fpm.d/www.conf"
    pattern ";listen.owner = nobody"
    line "listen.owner = nobody"
  end
  replace_or_add "add socket" do
    path "/etc/php-fpm.d/www.conf"
    pattern ";listen.group = nobody"
    line "listen.group = nobody"
  end
  replace_or_add "add socket" do
    path "/etc/php-fpm.d/www.conf"
    pattern "user = apache"
    line "user = nginx"
  end
  replace_or_add "add socket" do
    path "/etc/php-fpm.d/www.conf"
    pattern "group = apache"
    line "group = nginx"
  end 
  service 'php-fpm' do
    action [:enable, :start]
  end
  template '/etc/nginx/nginx.conf' do
    source 'nginx.erb'
    action :create
  end
  service 'nginx' do
    action [:enable, :start]
  end
  sqlpasses = data_bag_item('mysql','app_mysql')
  sqlpass="#{sqlpasses['app_user_pass']}"
  dbnodes = search(:node, "name:db1")
  template '/usr/share/nginx/html/index.php' do
    source 'index.erb'
    variables(sqlpassword: sqlpass, baseip: dbnodes.first["ipaddress"])
    action :create
  end
end
action :delete do
  package 'nginx' do
    action :remove
  end
  file '/var/www/html/index.html' do
    action :delete
  end
end
