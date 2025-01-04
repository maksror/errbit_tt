describe file('/etc/profile.d/rvm.sh') do
    it {should exist}
end

describe bash("source /etc/profile.d/rvm.sh && rvm list | head -1") do
    its('stdout') { should match (/^=\* ruby-2\.7\.6/) }
end
