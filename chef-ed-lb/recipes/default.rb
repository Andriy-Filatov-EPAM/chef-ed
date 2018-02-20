#
# Cookbook:: chef-ed-lb
# Recipe:: default
#
# Copyright:: 2018, Andriy Filatov
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

haproxy_install 'package'

haproxy_config_global '' do
  chroot '/var/lib/haproxy'
  daemon true
  maxconn 256
  log '/dev/log local0'
  log_tag 'WARDEN'
  pidfile '/var/run/haproxy.pid'
  stats socket: '/var/lib/haproxy/stats level admin'
  tuning 'bufsize' => '262144'
end

haproxy_config_defaults 'defaults' do
  mode 'http'
  timeout connect: '5000ms',
          client: '5000ms',
          server: '5000ms'
end

haproxy_frontend 'http-in' do
  bind '*:80'
  default_backend 'servers'
end

role = 'webserver'
app_backends = search(:node, "roles:#{role}")
server_array = ['disabled-server 127.0.0.1:1 disabled']

app_backends.each do |be|
  server_array.push("#{be['hostname']} #{be['ipaddress']}:80 maxconn 32")
end

haproxy_backend 'servers' do
  server server_array
end