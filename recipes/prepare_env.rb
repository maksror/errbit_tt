apt_update 'update'
package %w(ca-certificates build-essential gpg git)

group node['errbit']['group'] do
  action :create
end

user node['errbit']['user'] do
  gid node['errbit']['group']
  shell '/bin/bash'
  home node['errbit']['home_dir']
  manage_home true
  system true
  action :create
end
