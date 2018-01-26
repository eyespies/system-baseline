# Copyright (C) 2016 - 2017 Justin Spies
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
papertrail_host = attribute('papertrail_host', default: nil,
                            description: 'Hostname to be compred when testing that papertrail is properly configured')

control 'papertrail' do
  impact 1.0
  title 'Papertrail audit configuration'
  desc 'Provides controls to ensure that papertrail remote syslog configuration is accurate'

  describe package('rsyslog-gnutls') do
    it { should be_installed }
  end

  describe file('/var/spool/rsyslog') do
    it { should be_director }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
    its('mode') { should cmp '0770' }
  end

  describe file('/etc/papertrail-bundle.pem') do
    it { should be_director }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
    its('mode') { should cmp '0644' }
  end

  describe file('/etc/rsyslog.d/22-papertrail.conf') do
    it { should be_director }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
    its('mode') { should cmp '0644' }
    its(:content) { should match(/\*\.\*\s*#{papertrail_host}$/i) }
  end

  only_if { !papertrail_host.nil? }
end
