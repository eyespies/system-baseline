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
control 'yum-repositories' do
  impact 1.0
  title 'YUM Repository Configuration'
  desc 'Ensures that only allowed repositories exist given the specific platforms'

  # ~ Repo / Package Checks ~ #
  repos = case os.name
          when 'centos', 'redhat'
            %w[base updates epel]
          when 'oracle'
            if os[:release] =~ /^6/
              %w[public_ol6_latest epel]
            elsif os[:release] =~ /^7/
              %w[ol7_base_latest epel]
            else
              %w[]
            end
          else
            %w[]
          end

  repos.each do |repo|
    describe yum.repo(repo) do
      it { should exist }
      it { should be_enabled }
    end
  end
end
