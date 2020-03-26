# frozen_string_literal: true

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
localhost_only = attribute('listen_localhost_only',
                           default: 'false',
                           description: 'If true, Chrony should only listen on localhost and not expose the serivce to outside systems')

control 'chrony-services' do
  impact 1.0
  title 'Chrony - Network Time Protocol Service'
  desc 'chronyd - the latest time synchronization service'

  describe file('/etc/chrony.conf') do
    it { should exist }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
    its('mode') { should cmp '0644' }
    its(:content) { should match(%r{^logdir /var/log/chrony/i}) }
    its(:content) { should match(/^pool .* iburst/i) }
    # its(:content) { should match(/^keyfile \/etc\/chrony.keys/i) }
  end

  describe file('/etc/chrony.keys') do
    it { should exist }
    it { should be_owned_by('root') }
    it { should be_grouped_into('chrony') }
    its('mode') { should cmp '0640' }
  end

  # ~ Listening Ports Checks ~ #
  # TODO: Can we do listening on specific IPs?
  # TODO: Add negative testing for things that should NOT be listening
  describe port('323') do
    its(:addresses) { should include('127.0.0.1') }
    if localhost_only == 'true'
      its(:addresses) { should_not include('0.0.0.0') }
    else
      its(:addresses) { should include('0.0.0.0') }
    end
  end

  # ~ Service Checks ~ #
  chrony_service = 'chronyd'

  describe service(chrony_service) do
    it { should be_enabled }
    it { should be_running }
  end

  # ~ Process Checks ~ #
  describe processes('chronyd') do
    # Not currently working for somer reason.
    its('states') { should include('S') }
    its('entries.length') { should eq 1 }
  end
end
