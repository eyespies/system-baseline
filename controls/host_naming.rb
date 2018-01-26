default_domain = attribute('default_domain', default: '', description: 'Default domain used when checking the hostname')

control 'hostname' do
  impact 1.0
  title 'Custom Hostname Configuration'
  desc 'Ensure that the correct version of the AWS CLI is installed and configured'

  require 'json'

  attributes = json('/tmp/kitchen/dna.json')
  hostfile = file('/etc/hostname')

  describe file('/etc/hosts') do
    it { should exist }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
    its('mode') { should cmp '0644' }
    # TODO: add matchers
    its(:content) { should match(//i) }
  end

  hostname = hostfile.content.chomp

  domain = if attributes['system_core'].key?('domain')
           attributes['system_core']['domain']
         else
           # Default if no domain is present in the JSON file
           default_domain
         end

  # Check the domainname
  describe command('hostname -d') do
    its(:stdout) { should match(/^#{domain}$/i) }
  end

  # Check the hostname
  describe command('hostname -f') do
    its(:stdout) { should match(/^#{hostname}.#{domain}$/i) }
  end
end
