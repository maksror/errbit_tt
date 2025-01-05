include_recipe '::ruby_env'

# For running gem/bundle without env activation:
# https://rvm.io/integration/cron
wrappers_path = "#{node['errbit']['home_dir']}/.rvm/gems/ruby-#{node['errbit']['ruby_verion']}/wrappers"

# Workaround to avoid following error durring mini_racer install:
# ruby-2.7.6/gems/libv8-node-16.10.0.0-x86_64-linux-musl/vendor/v8/x86_64-linux/libv8/obj/libv8_monolith.a: No such file or directory
# Here is problem with wrong detected platform - 'x86_64-linux-musl' instead of 'x86_64-linux'
remote_file '/tmp/libv8-node-16.10.0.0-x86_64-linux.gem' do
    user node['errbit']['user']
    group node['errbit']['group']
    mode 0600

    source 'https://rubygems.org/downloads/libv8-node-16.10.0.0-x86_64-linux.gem'
end

bash '/tmp/libv8-node-16.10.0.0-x86_64-linux.gem' do
    user node['errbit']['user']
    group node['errbit']['group']
    login true

    code "#{wrappers_path}/gem install /tmp/libv8-node-16.10.0.0-x86_64-linux.gem"
end

bash 'gem install mini_racer' do
    user node['errbit']['user']
    group node['errbit']['group']
    login true

    code "#{wrappers_path}/gem install mini_racer --version 0.6.3 --platform x86_64-linux"
end

git node['errbit']['app_dir'] do
    user node['errbit']['user']
    group node['errbit']['group']

    repository 'https://github.com/errbit/errbit.git'
    action :sync
end

bash 'bundler install' do
    user node['errbit']['user']
    group node['errbit']['group']
    cwd node['errbit']['app_dir']
    login true

    code "#{wrappers_path}/bundler install"
end

bash 'bundle exec rake' do
    user node['errbit']['user']
    group node['errbit']['group']
    cwd node['errbit']['app_dir']
    login true
    
    flag_file = 'bootstrap_done'
    not_if { ::File.exists?(flag_file) }
    
    code "#{wrappers_path}/bundle exec rake errbit:bootstrap && touch #{flag_file}"
end

bash 'gem install sd_notify' do
    user node['errbit']['user']
    group node['errbit']['group']
    login true

    code "#{wrappers_path}/gem install sd_notify"
end

systemd_unit 'errbit.service' do
    content({ 
        Unit: {
            Description: 'errbit',
            After: 'network.target',
        },
        Service: {
            Type: 'notify',
            User: node['errbit']['user'],
            Group: node['errbit']['group'],
            WorkingDirectory: node['errbit']['app_dir'],
            ExecStart: "#{wrappers_path}/puma -b 'tcp://0.0.0.0:3000'",
            Restart: 'always',
            KillMode: 'process',
        },
        Install: {
            WantedBy: 'multi-user.target',
        }
    })
  action [:create, :enable, :start]
end
