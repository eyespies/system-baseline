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
default_domain = attribute('default_domain', default: '', description: 'Default domain used when checking the hostname')

control 'hostname' do
  impact 1.0
  title 'Custom Hostname Configuration'
  desc 'Ensure that the correct version of the AWS CLI is installed and configured'

  require 'json'

  attributes = json('/tmp/kitchen/dna.json')
  domain = if !attributes.content.nil? && attributes['system_core'].key?('domain')
             attributes['system_core']['domain']
           else
             # Default if no domain is present in the JSON file
             default_domain
           end

  hostfile = file('/etc/hostname')
  hostname = if !hostfile.content.nil?
               if domain.empty?
                 hostfile.content.chomp
               else
                 # Since #{hostname} is concated with #{domain}, the period is needed so that the comparison below
                 # is myhostname.mydomain.tld and not myhostnamemydomain.tld. If the period where added in the test
                 # itself and the domain were blank, the test would be 'hostname.' instead of just 'hostname'.
                 "#{hostfile.content.chomp}."
               end
             else
               ''
             end

  describe file('/etc/hosts') do
    it { should exist }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
    its('mode') { should cmp '0644' }
    # TODO: add matchers
    its(:content) { should match(//i) }
  end

  # Check the domainname
  describe command('hostname -d') do
    its(:stdout) { should match(/^#{domain}$/i) }
  end

  # Check the hostname
  describe command('hostname -f') do
    its(:stdout) { should match(/^#{hostname}#{domain}$/i) }
  end
end
