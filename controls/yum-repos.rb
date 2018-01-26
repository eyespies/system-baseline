control 'yum-repositories' do
  impact 1.0
  title 'YUM Repository Configuration'
  desc 'Ensures that only allowed repositories exist given the specific platforms'

  # ~ Repo / Package Checks ~ #
  repos = case os.name
          when 'centos', 'redhat'
            %w[base updates epel]
          when 'oracle'
            if os.release.to_s =~ /^6/
              %w[public_ol6_latest epel]
            elsif os.release.to_s =~ /^7/
              %w[ol7_base_latest epel]
            else
              skip "Unexpected os.family of #{os.family} version #{os.release}"
            end
          else
            skip "Unexpected os #{os.family} / #{os.name} / #{os.release}"
          end

  repos.each do |repo|
    describe yum.repo(repo) do
      it { should exist }
      it { should be_enabled }
    end
  end
end
