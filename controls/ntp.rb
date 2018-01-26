control 'ntp-services' do
  impact 1.0
  title 'Network Time Protocol Service'
  desc 'TBD'

  # TODO: What about /etc/ntp/keys and /etc/ntp/step-tickers?
  describe file('/etc/ntp.conf') do
    it { should exist }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
    its('mode') { should cmp '0644' }
    its(:content) { should match(/server [0-9].pool.ntp.org iburst minpoll [0-9] maxpoll [0-9]*/i) }
    its(:content) { should match(/restrict [0-9].pool.ntp.org nomodify notrap noquery/i) }
  end

  # ~ Listening Ports Checks ~ #
  # TODO: Can we do listening on specific IPs?
  # TODO: Add negative testing for things that should NOT be listening
  describe port('123') do
    its(:protocols) { should include('udp') }
    its(:addresses) { should include('0.0.0.0') }
  end

  # ~ Service Checks ~ #
  describe service('ntpd') do
    it { should be_enabled }
    it { should be_running }
  end

  # ~ Process Checks ~ #
  commands = if os[:release] =~ /^6/
               'ntpd -u ntp:ntp -p /var/run/ntpd.pid -g'
             elsif os[:release] =~ /^7/
               '/usr/sbin/ntpd -u ntp:ntp -g'
             end

  describe processes('ntpd') do
    # Not currently working for somer reason.
    its('states') { should include('Ss') }
    its('entries.length') { should eq 1 }
    its('commands') { should include(commands) }
  end
end
