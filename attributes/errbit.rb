default['errbit']['user'] = 'errbit'
default['errbit']['group'] = 'errbit'
default['errbit']['home_dir'] = "/home/#{default['errbit']['user']}"
default['errbit']['app_dir'] = "#{default['errbit']['home_dir']}/errbit"

# Don't change this attr. Errbit requires ruby 2.7
default['errbit']['ruby_verion'] = '2.7.6'

# Be carefull
# Email should be valid(for example test@test not accepted due to invalid domain name)
# Password chould be strong enough
default['errbit']['admin_email'] = 'test@test.test'
default['errbit']['password'] = 'change@me@p1ease'

default['errbit']['ip'] = '0.0.0.0'
default['errbit']['port'] = '3000'
