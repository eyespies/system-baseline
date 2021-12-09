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
