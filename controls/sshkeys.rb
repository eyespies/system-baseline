control 'sshkeys' do
  impact 1.0
  title 'Secure Shell Key Installation'
  desc 'Confirms that the SSH public/private keys are installed for the root user'

  describe file('/root/.ssh') do
    it { should be_directory }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
    its('mode') { should cmp '0700' }
  end

  describe file('/root/.ssh/authorized_keys') do
    it { should exist }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
    its('mode') { should cmp '0600' }
    # TODO: We could add a command to check the number of lines.
    its(:size) { should > 0 }
    its(:content) { should match(/^ssh-(rsa|dsa)\s.*/) }
  end

  %w[id_rsa-test id_rsa-test.pub].each do |key_file|
    describe file("/root/.ssh/#{key_file}") do
      it { should exist }
      it { should be_owned_by('root') }
      it { should be_grouped_into('root') }
      its('mode') { should cmp '0600' }
      its(:size) { should > 0 }
    end
  end
end
