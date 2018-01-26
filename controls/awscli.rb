control 'awscli' do
  impact 1.0
  title 'Amazon Web Services CLI'
  desc 'Ensure that the correct version of the AWS CLI is installed and configured'

  pip_package = if os[:release] =~ /^6/
                  'python-pip'
                elsif os[:release] =~ /^7/
                  'python2-pip'
                end

  describe package(pip_package) do
    it { should be_installed }
  end

  packages = { 'jq' => nil, 'wget' => nil, 'curl' => nil, 'unzip' => nil }
  packages.each do |pkg, vers|
    describe package(pkg) do
      it { should be_installed }
      it { should be_installed.with_version(vers) } unless vers.nil?
    end
  end

  describe file('/root/.aws') do
    it { should be_directory }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
    its('mode') { should cmp '0750' }
  end

  describe file('/root/.aws/config') do
    it { should exist }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
    its('mode') { should cmp '0640' }
    its('size') { should > 0 }
    # TODO: Add file content checks
  end

  describe file('/root/.aws/credentials') do
    it { should exist }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
    its('mode') { should cmp '0640' }
    its('size') { should > 0 }
    # TODO: Add file content checks
  end
end
