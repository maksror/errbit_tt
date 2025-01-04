apt_update 'update'

package %w(ca-certificates gpg)


openssl_deb_url = case node['platform']
                  when 'ubuntu'
                    'http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb'
                  when 'debian'
                    'http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.1_1.1.1w-0+deb11u2_amd64.deb'
                  end

remote_file '/tmp/libssl1.1_1.1.1.deb' do
    source openssl_deb_url
    mode 644
end

dpkg_package 'libssl1.1_1.1.1' do
    source '/tmp/libssl1.1_1.1.1.deb'
    action :install
end

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
