# Use the official Nextcloud image as a base
FROM nextcloud:latest

USER www-data 

WORKDIR /var/www/html/occ

# Run commands to disable unwanted apps
# These commands use Nextcloud's occ command-line tool
RUN php app:disable dashboard \
    && php occ app:disable circles \
    && php occ app:disable weather_status \
    && php occ app:disable activity \
    && php occ app:disable photos \
    && php occ app:disable recommendations \
    && php occ app:disable firstrunwizard \
    && php occ app:disable nextcloud_announcements \
    && php occ app:disable contactsinteraction

# Modify the config.php to set the skeletondirectory to an empty string
RUN sed -i "/);/i 'skeletondirectory' => ''," /var/www/html/config/config.php
