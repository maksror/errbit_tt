mongodb_version = '8.0'
platform_version = node['platform_version'].split('.').first.to_i

if node['platform'] == 'debian' 
    case platform_version
    when 11 then mongodb_version = '7.0'
    when 10 then mongodb_version = '6.0'
    end
end

apt_repository "mongodb-#{mongodb_version}" do
    uri "https://repo.mongodb.org/apt/#{node['platform']}"
    distribution "#{node['lsb']['codename']}/mongodb-org/#{mongodb_version}"
    components platform?('ubuntu') ? ['multiverse'] : ['main']
    key "https://www.mongodb.org/static/pgp/server-#{mongodb_version}.asc"
end

package 'mongodb-org' do
    action :install
end

service 'mongod' do
    action [:enable, :start]
end
