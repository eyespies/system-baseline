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
control 'sshkeys' do
  impact 1.0
  title 'Secure Shell Key Installation'
  desc 'Confirms that the SSH public/private keys are installed for the root user'

  describe file('/root/.ssh') do
    it { should be_directory }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
    its('mode') { should cmp '0700' }
  end

  describe file('/root/.ssh/authorized_keys') do
    it { should exist }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
    its('mode') { should cmp '0600' }
    # TODO: We could add a command to check the number of lines.
    its(:size) { should > 0 }
    its(:content) { should match(/^ssh-(rsa|dsa)\s.*/) }
  end

  %w[id_rsa-test id_rsa-test.pub].each do |key_file|
    describe file("/root/.ssh/#{key_file}") do
      it { should exist }
      it { should be_owned_by('root') }
      it { should be_grouped_into('root') }
      its('mode') { should cmp '0600' }
      its(:size) { should > 0 }
    end
  end
end
