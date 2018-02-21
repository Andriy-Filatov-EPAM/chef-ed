# # encoding: utf-8

# Inspec test for recipe webserver::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

# This is an example test, replace it with your own test.
require 'chefspec'

describe 'webserver::nginx' do
	let(:chef_run) {
   		ChefSpec::SoloRunner.new(step_into: ['indexpage']).converge('webserver::nginx')
	}
        it 'installs nginx' do
		expect(chef_run).to install_package('nginx')
	end
	it 'enable nginx' do
		expect(chef_run).to enable_service('nginx')
	end
	it 'creates index.html form template' do
		expect(chef_run).to create_template('/usr/share/nginx/html/index.html')
	end
end
