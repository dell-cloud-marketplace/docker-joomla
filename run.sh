#!/bin/bash

VOLUME_HOME="/var/lib/mysql"
APPLICATION_HOME="/var/www/html/"

sed -ri -e "s/^upload_max_filesize.*/upload_max_filesize = ${PHP_UPLOAD_MAX_FILESIZE}/" \
    -e "s/^post_max_size.*/post_max_size = ${PHP_POST_MAX_SIZE}/" /etc/php5/apache2/php.ini

# Create the database if it doesn't exist.
if [[ ! -d $VOLUME_HOME/mysql ]]; then
    echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME"
    echo "=> Installing MySQL ..."
    mysql_install_db > /dev/null 2>&1
    echo "=> Done!"  
    /create_mysql_users.sh
else
    echo "=> Using an existing volume of MySQL"
fi

# If the application directory is empty, copy the application site.
if [ ! "$(ls -A $APPLICATION_HOME)" ]; then
    # Copy Joomla files.
    cp -R /tmp/joomla/* $APPLICATION_HOME

    # Update permissions
    chown -R www-data.www-data /var/www/html/
    chmod -R 775 /var/www/html/
fi

exec supervisord -n
