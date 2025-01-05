remote_file '/tmp/install_rvm.sh' do
    user node['errbit']['user']
    group node['errbit']['group']
    source 'https://get.rvm.io'
    mode 0600
end

rvm_bin = "#{node['errbit']['home_dir']}/.rvm/bin/rvm"

bash 'install rvm' do
    not_if { ::File.exist?(rvm_bin) }

    user node['errbit']['user']
    group node['errbit']['group']
    login true

    code 'bash /tmp/install_rvm.sh'    
end

# Install rvm dependencies over root user
bash 'install rvm requirements' do
    code "#{rvm_bin} requirements"
end

# Build openssl for newer OS versions
ruby_install_opt = ''
platform_version = node['platform_version'].split('.').first.to_i

if (node['platform'] == 'ubuntu' && platform_version > 20) || (node['platform'] == 'debian' && platform_version > 10)
    bash 'compile openssl for ruby' do
        usr_lib_path = "#{node['errbit']['home_dir']}/.rvm/usr"
        ruby_install_opt = "--with-openssl-dir=#{usr_lib_path}"

        not_if { File.exist?("#{usr_lib_path}/bin/openssl") }

        user node['errbit']['user']
        group node['errbit']['group']
        login true

        code <<-EOH
            source ~/.rvm/scripts/rvm
            rvm pkg install openssl
        EOH
    end 
end
    
bash "install ruby #{node['errbit']['ruby_verion']}" do
    user node['errbit']['user']
    group node['errbit']['group']
    login true

    code <<-EOH
        source ~/.rvm/scripts/rvm
        rvm install ruby-#{node['errbit']['ruby_verion']} #{ruby_install_opt}
    EOH
end

bash 'setup default ruby' do
    user node['errbit']['user']
    group node['errbit']['group']
    login true

    code <<-EOH
        source ~/.rvm/scripts/rvm
        rvm --default use ruby-#{node['errbit']['ruby_verion']}
    EOH
end

