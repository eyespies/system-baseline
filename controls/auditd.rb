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
control 'auditd' do
  impact 1.0
  title 'Linux Server Audit Services'
  desc 'Provides controls to ensure that the auditd service is running'

  # TODO: Is this Cent/Oracle/RHEL 7 specific?
  if os[:release] =~ /^7/ || os[:release] =~ /^1[68]/
    describe processes('auditd') do
      its('entries.length') { should eq 1 }
      its('users') { should cmp 'root' }
    end
  end
end
