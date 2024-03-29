# frozen_string_literal: true

# Copyright:: (C) 2016 - 2020 Justin Spies
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# rubocop:disable Metrics/BlockLength
control 'ssh-daemon' do
  impact 1.0
  title 'Secure Shell Server Daemon'
  desc 'TBD'

  ciphers = case os.name
            when 'centos', 'redhat', 'oracle'
              %w(chacha20-poly1305@openssh.com
                 aes128-ctr
                 aes192-ctr
                 aes256-ctr
                 aes128-gcm@openssh.com
                 aes256-gcm@openssh.com)
            end

  macs = case os.name
         when 'centos', 'redhat', 'oracle'
           %w(umac-64-etm@openssh.com
              umac-128-etm@openssh.com
              hmac-sha2-256-etm@openssh.com
              hmac-sha2-512-etm@openssh.com
              hmac-sha1-etm@openssh.com
              umac-64@openssh.com
              umac-128@openssh.com
              hmac-sha2-256
              hmac-sha2-512
              hmac-sha1
              hmac-sha1-etm@openssh.com)
         end

  sshd_file_perms = case os.name
                    when 'redhat', 'centos', 'oracle'
                      '0600'
                    else
                      '0644'
                    end

  sftp_subsystem_regex = case os.name
                         when 'redhat', 'centos', 'oracle'
                           "Subsystem\s*sftp /usr/libexec/openssh/sftp-server"
                         else
                           "Subsystem\s*sftp /usr/lib/openssh/sftp-server"
                         end

  describe file('/etc/ssh/sshd_config') do
    it { should exist }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp sshd_file_perms }
    its(:content) { should match(%r{Banner\s*/etc/ssh/banner}i) }
    its(:content) { should match(/LoginGraceTime\s*1m/i) }
    its(:content) { should match(/AllowGroups\s*/i) }
    its(:content) { should match(/Protocol\s*2/i) }
    its(:content) { should match(/SyslogFacility\s*AUTHPRIV/i) }
    its(:content) { should match(%r{HostKey\s*/etc/ssh/ssh_host_(dsa|ecdsa)_key}i) }
    its(:content) { should match(/PasswordAuthentication\s*yes/i) }
    its(:content) { should match(/KerberosAuthentication\s*no/i) }
    its(:content) { should match(/UsePAM\s*yes/i) }
    its(:content) { should match(/X11Forwarding\s*no/i) }
    its(:content) { should match(/#{sftp_subsystem_regex}/i) }
    its(:content) { should match(/Ciphers\s*#{ciphers.join(',')}/i) } unless ciphers.nil?
    its(:content) { should match(/Macs\s*#{macs.join(',')}/i) } unless macs.nil?

    # How to test file changes based on environmental conditions, e.g.:
    # if File.exist?('/usr/bin/sss_ssh_authorizedkeys') && File.exist?('/etc/ipa/ca.crt')
    #  # Override the default SSH settings - these are required in order to enable use of SSH keys stored in IPA
    #  node.override['openssh']['server']['AuthorizedKeysCommand'] = '/usr/bin/sss_ssh_authorizedkeys'
  end

  describe file('/etc/ssh/banner') do
    it { should exist }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0664' }
  end
  # NOTE: Not testing for the groups to be created in Vagrant because the tests will almost always be in Vagrant

  # ~ Listening Ports Checks ~ #
  describe port('22') do
    its(:protocols) { should include('tcp') }
    its(:addresses) { should include('0.0.0.0') }
  end

  # ~ Service Checks ~ #
  describe service('sshd') do
    it { should be_enabled }
    it { should be_running }
  end

  # ~ Process Checks ~ #
  describe processes('sshd') do
    its('states') { should include('Ss') }
    its('entries.length') { should eq 1 }
    # No test for the user because it seems to take to long to restart and the check always returns 'root', however
    # when logging into the box using 'kitchen login' and running the exact same command that ServerSpec uses,
    # the test returns the correct 'ntp' user. Go figure.
    its('users') { should cmp 'root' }
  end
end
# rubocop:enable Metrics/BlockLength
