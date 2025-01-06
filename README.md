
# errbit_tt cookbook

## Definitions

This cookbook installs [errbit](https://github.com/errbit/errbit) from scratch along with the necessary software to run it.
The installation includes:
1. MongoDB latest version available for the OS(6.0+).
2. Installing and configuring a local [ruby environment](https://rvm.io/rvm/install#installation) for the errbit user.
3. Configuring errbit to run as a puma-based systemd unit.

## Supported OS

 - Ubuntu 20, 22, 24
 - Debian 10, 11, 12

## Requirements

### Cookbooks

- none

### Chef Infra Client

- Chef Infra Client 17+


## Attributes

## Errbit.rb
Be careful, attribute validation is entirely on you.
#### System user and application location
- `default['errbit']['user']` - System user under which errbit will be run
- `default['errbit']['group']` -System user group
- `default['errbit']['home_dir']` - User home directory
- `default['errbit']['app_dir']` - Application directory
#### Admin login and password
- `default['errbit']['admin_email']` - Errbit admin email
- `default['errbit']['password']` - Errbit admin password
#### Puma IP and host
- `default['errbit']['ip']` - From which address to accept connections, default is 0.0.0.0
- `default['errbit']['port']` - Port the errbit listens on, default is 3000

## Notes

If you want to rerun the cookbook, but have already gone through the `run bootstrap` step, then delete the `bootstrap_done` file from the errbit application directory