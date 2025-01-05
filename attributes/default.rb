default['is_legasy_os'] = false

# Detect legasy OS(Ubuntu 20 and Debian 10) for systemd unit and compiling openssl for ruby
# For legasy OS systemd unit will be with 'simple' type istead of 'notify'
# For new OS for ruby will be compiled old openssl
platform_version = node['platform_version'].split('.').first.to_i
if (node['platform'] == 'ubuntu' && platform_version == 20) || (node['platform'] == 'debian' && platform_version == 10)
    default['is_legasy_os'] = true
end
