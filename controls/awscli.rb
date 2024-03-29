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
control 'awscli' do
  impact 1.0
  title 'Amazon Web Services CLI'
  desc 'Ensure that the correct version of the AWS CLI is installed and configured'

  pip_package = case os[:release]
                when /^7/
                  'python2-pip'
                when /^(8|18|20)/
                  'python3-pip'
                end

  describe package(pip_package) do
    it { should be_installed }
  end

  packages = { 'jq' => nil, 'wget' => nil, 'curl' => nil, 'unzip' => nil }
  packages.each do |pkg, vers|
    describe package(pkg) do
      it { should be_installed }
      it { should be_installed.with_version(vers) } unless vers.nil?
    end
  end

  describe file('/root/.aws') do
    it { should be_directory }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
    its('mode') { should cmp '0750' }
  end
end
