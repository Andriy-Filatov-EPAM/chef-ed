name 'webserver'
maintainer 'Sergei Morozov'
maintainer_email 'ghostshadow@sairanor.ru'
license 'GPL-3.0'
description 'Installs/Configures webserver'
long_description 'Installs/Configures webserver'
version '0.1.1'
chef_version '>= 12.1' if respond_to?(:chef_version)
supports 'ubuntu'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
issues_url 'https://git.sairanor.ru/shed/webserver/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
source_url 'https://git.sairanor.ru/shed/webserver'
depends 'line'
depends 'selinux', '~> 2.1.0'