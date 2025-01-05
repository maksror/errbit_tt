control 'errbit' do
    title ''

    port_to_check = 3000
    interval = 1
    timeout = 10

    # Avoiding situations when errbit takes a long time to start up
    start_time = Time.now
    loop do
      break if port(port_to_check).listening? || (Time.now - start_time) > timeout
      sleep(interval)
    end

    describe service('errbit') do
        it { should be_enabled }
        it { should be_running }
    end

    describe port(port_to_check) do
        it { should be_listening }
        its('addresses') { should include '0.0.0.0' }
    end
end
