package %w(git build-essential)

remote_file '/tmp/libv8-node-16.10.0.0-x86_64-linux.gem' do
    source 'https://rubygems.org/downloads/libv8-node-16.10.0.0-x86_64-linux.gem'
    mode 600
end

bash '/tmp/libv8-node-16.10.0.0-x86_64-linux.gem' do
    code 'source /etc/profile.d/rvm.sh && gem install /tmp/libv8-node-16.10.0.0-x86_64-linux.gem'
end

bash 'gem install mini_racer' do
    code 'source /etc/profile.d/rvm.sh && gem install mini_racer --version 0.6.3 --platform x86_64-linux'
end

git '/home/errbit' do
    repository 'https://github.com/errbit/errbit.git'
    action :sync
end

bash 'bundler install' do
    cwd '/home/errbit'
    code 'source /etc/profile.d/rvm.sh && bundler install'
end
