name 'chef-ed-lb'
maintainer 'Andriy Filatov'
maintainer_email 'andriy_filatov@epam.com'
license 'GPL-3.0'
description 'Chef-ED LB Role'
long_description 'Chef-ED LB Role'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)
issues_url 'https://github.com/Andriy-Filatov-EPAM/chef-ed/issues'
source_url 'https://github.com/Andriy-Filatov-EPAM/chef-ed'

depends 'haproxy', '~> 5.0.3'