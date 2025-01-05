control 'Errbit' do
    title 'Verify errbit application'

    describe service('errbit') do
        it { should be_enabled }
        it { should be_running }
    end

    describe port(3001) do
        it { should be_listening }
        its('addresses') { should include '0.0.0.0' }
    end
end
