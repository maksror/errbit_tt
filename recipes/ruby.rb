remote_file '/tmp/install_rvm.sh' do
    source 'https://get.rvm.io'
    mode 600
end

bash 'install rvm' do
    code '/tmp/install_rvm.sh'    
end

ruby_install_opt = ''
platform_version = node['platform_version'].split('.').first.to_i

if (node['platform'] == 'ubuntu' && platform_version > 20) || (node['platform'] == 'debian' && platform_version > 10)
    bash 'compile openssl for ruby' do
        code 'source /etc/profile.d/rvm.sh && rvm pkg install openssl'
        ruby_install_opt = '--with-openssl-dir=/usr/local/rvm/usr'
    end 
end
    

bash 'install ruby 2.7.6' do
    code "source /etc/profile.d/rvm.sh && rvm install ruby-2.7.6 #{ruby_install_opt} && rvm --default use ruby-2.7.6"
end
