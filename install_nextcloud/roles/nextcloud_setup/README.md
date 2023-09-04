# Ansible Role for Secure Nextcloud Installation

## Overview

This Ansible role automates the installation and configuration of Nextcloud, including necessary security configurations such as permissions and database setup.

## Requirements

- A server running Ubuntu 20.04 LTS or any compatible distribution.
- SSH access to the target server.
- Ansible 2.9+ installed on your local machine or control node.
- Python and required Python libraries installed on the target host.

## Role Variables

Here are the variables that can be configured:

- `dir_nextcloud`: Directory where Nextcloud will be installed.
- `db_name`: Name of the MySQL database for Nextcloud.
- `mysql_root_passwd`: Root password for MySQL.
- `mysql_user`: MySQL username for Nextcloud.
- `mysql_nextcloud_passwd`: Password for the Nextcloud MySQL user.
- `nc_admin`: Admin username for Nextcloud.
- `nc_passwd`: Admin password for Nextcloud.
- `db_type`: Database type (default is 'mysql').
- `mail_addr`: Admin email address.
- `nc_config`: Nextcloud configuration options as key-value pairs.

## Dependencies

No external roles are required for this role.

## Example Playbook

Here's an example playbook on how to use this role:

```yaml
- hosts: nextcloud_server
  vars:
    dir_nextcloud: "/var/www/nextcloud"
    db_name: "nextcloud_db"
    mysql_root_passwd: "strong_root_password"
    mysql_user: "nextcloud_user"
    mysql_nextcloud_passwd: "strong_user_password"
    nc_admin: "admin"
    nc_passwd: "strong_admin_password"
    db_type: "mysql"
    mail_addr: "admin@example.com"
    nc_config:
      - { key: 'trusted_domains', value: 'your_domain.com' }
  roles:
    - secure_nextcloud_installation
```

## Handlers

Make sure to include handlers for restarting Apache and MySQL if you use `notify` in the role tasks:

- `Restart apache`
- `Restart mysql`

## Security

For production environments, it is advised to secure sensitive variables like passwords using Ansible Vault.

## License

MIT

## Author Information

This role was created in 2023 by [Mehdi B.]
