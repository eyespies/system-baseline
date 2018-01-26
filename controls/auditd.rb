control 'auditd' do
  impact 1.0
  title 'Linux Server Audit Services'
  desc 'Provides controls to ensure that the auditd service is running'

  # TODO: Is this Cent/Oracle/RHEL 7 specific?
  if os.release.to_s =~ /^7/
    # TODO: Below
    # describe auditd_conf do
    #  its('log_file') { }
    #  its('log_format') { }
    #  its('flush') { }
    #  its('freq') { }
    #  its('space_left') { }
    # end

    describe processes('auditd') do
      its('entries.length') { should eq 1 }
      its('users') { should cmp 'root' }
    end
  end
end
