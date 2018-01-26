control 'bash' do
  impact 1.0
  title 'Bourne Again Shell Configuration'
  desc 'Ensure that bash defaults are properly configured'

  describe file('/etc/profile') do
    it { should exist }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
    its('mode') { should cmp '0644' }
    its(:size) { should > 1000 }
    its(:content) { should match(/HISTSIZE=10000/i) }
    its(:content) { should match(/HISTTIMEFORMAT="%F-%H.%M.%S "/i) }
    its(:content) { should match(/export PATH USER LOGNAME MAIL HOSTNAME HISTSIZE HISTTIMEFORMAT HISTCONTROL/i) }
  end

  describe file('/etc/profile.d/smiley.sh') do
    it { should exist }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
    its('mode') { should cmp '0644' }
    its(:size) { should > 500 }
  end
end
