

# Secure Nextcloud Installation Guide

## Overview

This document provides a guide to install Nextcloud in a secure manner. Follow the steps for a comprehensive setup.

## Prerequisites

- A server running Ubuntu 20.04 or similar OS
- SSH access to the server
- Domain name pointed to your server

## Installation Steps

### Operating System

- Update your system packages:

  ```bash
  sudo apt update && sudo apt upgrade -y
  ```

### Database

1. Install MariaDB:

  ```bash
  sudo apt install mariadb-server mariadb-client -y
  ```

2. Secure your MariaDB installation:

  ```bash
  sudo mysql_secure_installation
  ```

### Web Server

1. Install Apache web server:

  ```bash
  sudo apt install apache2 -y
  ```

2. Enable necessary modules:

  ```bash
  sudo a2enmod rewrite headers env dir mime
  ```

### Nextcloud

1. Download Nextcloud:

  ```bash
  wget https://download.nextcloud.com/server/releases/nextcloud-x.y.z.zip
  ```

2. Extract and move to web directory:

  ```bash
  unzip nextcloud-x.y.z.zip
  sudo mv nextcloud /var/www/
  ```

3. Set permissions:

  ```bash
  sudo chown -R www-data:www-data /var/www/nextcloud/
  ```

4. Configure Apache:

  - Copy `nextcloud.conf` to `/etc/apache2/sites-available/`
  - Enable site `sudo a2ensite nextcloud.conf`
  - Reload Apache `sudo systemctl reload apache2`

## Security Measures

### Firewall

- Enable UFW:

  ```bash
  sudo ufw enable
  ```

- Allow only necessary ports:

  ```bash
  sudo ufw allow 22,80,443/tcp
  ```

### SSL

1. Install Let's Encrypt:

  ```bash
  sudo apt install certbot python3-certbot-apache -y
  ```

2. Generate certificate:

  ```bash
  sudo certbot --apache
  ```

### Data Encryption

- Follow Nextcloud's data encryption documentation.

## Backup

- Take periodic backups of Nextcloud data and database.

## Troubleshooting

- Check logs at `/var/log/apache2/` and `/var/www/nextcloud/data/nextcloud.log`

## Contributors

- [Mehdi B.]
