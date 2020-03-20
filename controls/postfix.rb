# Copyright (C) 2016 - 2020 Justin Spies
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
control 'mail' do
  impact 1.0
  title 'Postfix Mail Services'
  desc 'TBD'
  title 'Postfix Mail Service'

  package('postfix') do
    it { should be_installed }
  end

  file('/etc/postfix/master.cf') do
    it { should exist }
    its(:owner) { should eq 'root' }
    its(:group) { should eq 'root' }
    its('mode') { should cmp '0644' }
  end

  file('/etc/postfix/main.cf') do
    it { should exist }
    its(:owner) { should eq 'root' }
    its(:group) { should eq 'root' }
    its('mode') { should cmp '0644' }
    # TODO: How to match this properly since it changes per platform + test suite?
    its(:content) { should match(/mydestination\s*=\s*/) }
    its(:content) { should match(%r{alias_databases\s*=\s*hash:/etc/aliases}) }
    its(:content) { should match(%r{alias_maps\s*=\s*hash:/etc/aliases}) }
    its(:content) { should match(%r{sender_canonical_maps\s*=\s*hash:/etc/postfix/sender_canonical}) }
    its(:content) { should match(/mydomain\s*=\s*/) }
    its(:content) { should match(/myhostname\s*=\s*/) }
    its(:content) { should match(/myorigin\s*=\s*\$myhostname/) }

    # Required to send email through SES
    its(:content) { should match(/smtp_sasl_auth_enable\s*=\s*yes/) }
    its(:content) { should match(%r{smtp_sasl_password_maps\s*=\s*hash:/etc/postfix/sasl_passwd}) }
    its(:content) { should match(/smtp_sasl_security_options\s*=\s*noanonymous/) }
    its(:content) { should match(%r{smtp_tls_CAfile\s*=\s*/etc/ssl/certs/ca-bundle.crt}) }
    its(:content) { should match(/smtp_tls_note_starttls_offer\s*=\s*yes/) }
    its(:content) { should match(/smtp_tls_security_level\s*=\s*encrypt/) }
    its(:content) { should match(/smtpd_use_tls\s*=\s*yes/) }
  end

  file('/etc/postfix/access') do
    it { should exist }
    its(:owner) { should eq 'root' }
    its(:group) { should eq 'root' }
    its('mode') { should cmp '0644' }
  end

  file('/etc/aliases') do
    it { should exist }
    its(:owner) { should eq 'root' }
    its(:group) { should eq 'root' }
    its('mode') { should cmp '0644' }
  end

  file('/etc/aliases.db') do
    it { should exist }
    its(:owner) { should eq 'root' }
    its(:group) { should eq 'root' }
    its('mode') { should cmp '0644' }
  end

  file('/etc/postfix/canonical') do
    it { should exist }
    its(:owner) { should eq 'root' }
    its(:group) { should eq 'root' }
    its('mode') { should cmp '0644' }
  end

  file('/etc/postfix/generic') do
    it { should exist }
    its(:owner) { should eq 'root' }
    its(:group) { should eq 'root' }
    its('mode') { should cmp '0644' }
  end

  file('/etc/postfix/header_checks') do
    it { should exist }
    its(:owner) { should eq 'root' }
    its(:group) { should eq 'root' }
    its('mode') { should cmp '0644' }
  end

  file('/etc/postfix/relocated') do
    it { should exist }
    its(:owner) { should eq 'root' }
    its(:group) { should eq 'root' }
    its('mode') { should cmp '0644' }
  end

  file('/etc/postfix/sasl_passwd') do
    it { should exist }
    its(:owner) { should eq 'root' }
    its(:group) { should eq 'root' }
    its('mode') { should cmp '0400' }
  end

  file('/etc/postfix/sasl_passwd') do
    it { should exist }
    its(:owner) { should eq 'root' }
    its(:group) { should eq 'root' }
    its('mode') { should cmp '0400' }
  end

  file('/etc/postfix/transport') do
    it { should exist }
    its(:owner) { should eq 'root' }
    its(:group) { should eq 'root' }
    its('mode') { should cmp '0644' }
  end

  file('/etc/postfix/virtual') do
    it { should exist }
    its(:owner) { should eq 'root' }
    its(:group) { should eq 'root' }
    its('mode') { should cmp '0644' }
  end

  describe service('postfix') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port('25') do
    its(:protocols) { should include('tcp') }
    its(:addresses) { should include('127.0.0.1') }
  end
end
