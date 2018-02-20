# Chef-ED


## Chef-Server

### Run Chef-Server in Docker

1. Run Chef-Server in container
```bash
docker run --privileged -t --name chef-server -d -p 443:443 cbuisson/chef-server
```
2. Follow the installation
```bash
docker logs -f chef-server
```

>   Note: The container needs to be DNS resolvable!
>   Be sure 'chef-server' is pointing to the container's IP!
>   So You should add your **chef-server** ip to your **/etc/hosts**,
>   otherwise you'll have an SSL issue

```bash
$ grep chef-server /etc/hosts
192.168.88.205 chef-server
```

3. Download Knife admin keys
```bash
curl -Ok https://chef-server/knife_admin_key.tar.gz
```

4.  config.rb example:

```ruby
log_level                :info
log_location             STDOUT
cache_type               'BasicFile'
node_name                'admin'
client_key               '/path/to/your/.chef/admin.pem'
validation_client_name   'my_org-validator'
validation_key           '/path/to/your/.chef/my_org-validator.pem'
chef_server_url          'https://chef-server:$SSL_PORT/organizations/my_org'
ssl_verify_mode          :verify_none
```
5. Get the SSL certificate file from your container to access Chef Server
```bash
knife ssl fetch
```
6. Test your Knife
```bash
knife user list
```
>   You should see following: 
```
admin
```

## Install Chef-Server in Centos VM

1. Install chef-server rpm
```bash
yum install -y https://packages.chef.io/files/stable/chef-server/12.17.15/el/7/chef-server-core-12.17.15-1.el7.x86_64.rpm
```
2. Install chef-server it self
```bash
chef-server-ctl reconfigure
```

3. Create your admin user
```bash
chef-server-ctl user-create admin FIRST_NAME LAST_NAME admin@chef-server.localnet 'PASSWORD' --filename /etc/chef/admin.pem
```

4. Create your organization
```bash
chef-server-ctl org-create my_org "Default organization" --association_user admin --filename /etc/chef/my_org-validator.pem
```

5. Install chef-server UI
```bash
chef-server-ctl install chef-manage && chef-server-ctl reconfigure && chef-manage-ctl reconfigure --accept-license
```

## Knife commands

### Install cookbook dependancies

```bash
berks install
```

### Upload cookbook to chef-server

```bash
knife cookbook upload --cookbook-path . chef-ed-web
```

### Bootstrap chef-client

```bash
knife bootstrap 192.168.88.199 -x root -P password -N web-node
```

### Create new role

```bash
knife role create webserver
```

### Add cookbook to role run-list

```bash
knife role run_list add webserver recipe[chef-ed-web]
```

### Add role to node run-list

```bash
knife node run_list add chef-ed-web-node role[webserver]
```

### Run chef-client on remote node

```bash
knife ssh "role:webserver" "chef-client" -x root -P password
```
