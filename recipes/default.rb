include_recipe '::mongodb'
include_recipe '::ruby'
include_recipe '::errbit_env'

bash 'bundle exec rake' do
    cwd '/home/errbit'
    code 'source /etc/profile.d/rvm.sh && bundle exec rake errbit:bootstrap'
end

systemd_unit 'errbit.service' do
    content({ 
        Unit: {
            Description: 'errbit',
            After: 'network.target',
        },
        Service: {
            Type: 'simple',
            User: 'root',
            Group: 'root',
            WorkingDirectory: '/home/errbit',
            ExecStart: '/bin/bash -c \'source /etc/profile.d/rvm.sh && bundle exec puma -b "tcp://0.0.0.0:3000"\'',
            Restart: 'always',
            KillMode: 'process',
        },
        Install: {
            WantedBy: 'multi-user.target',
        }
    })
  action [:create, :enable, :start]
end
