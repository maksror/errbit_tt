control 'Errbit' do
    title ''

    describe service('errbit') do
        it { should be_enabled }
        it { should be_running }
    end

    describe port(3000) do
        it { should be_listening }
        its('addresses') { should include '0.0.0.0' }
    end
end
