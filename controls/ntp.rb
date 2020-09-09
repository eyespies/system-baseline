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
                           value: 'false',
                           description: 'If true, NTP should only listen on localhost and not expose the serivce to outside systems')

if os.redhat? && os[:release] =~ /^[67]/
  control 'ntp-services' do
    impact 1.0
    title 'Network Time Protocol Service'
    desc 'Validates the installation and configuration of the NTP service'

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
      its(:addresses) { should include('127.0.0.1') }
      if localhost_only == 'true'
        its(:addresses) { should_not include('0.0.0.0') }
      else
        its(:addresses) { should include('0.0.0.0') }
      end
    end

    # ~ Service Checks ~ #
    ntp_service = case os.name
                  when 'centos', 'redhat', 'oracle'
                    'ntpd'
                  when 'debian', 'ubuntu'
                    'ntp'
                  end

    describe service(ntp_service) do
      it { should be_enabled }
      it { should be_running }
    end

    # ~ Process Checks ~ #
    describe processes('ntpd') do
      # Not currently working for somer reason.
      its('states') { should include('Ss') }
      its('entries.length') { should eq 1 }
    end
  end
end
