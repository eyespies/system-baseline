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
  # This should always have a value in the JSON file since it is specifically testing an override of the default.
  domain = attributes['system_core']['domain']

  # Check the domainname
  describe command('hostname -d') do
    its(:stdout) { should match(/^#{domain}$/i) }
  end

  # Check the hostname
  describe command('hostname -f') do
    its(:stdout) { should match(/^#{hostname}.#{domain}$/i) }
  end
end
