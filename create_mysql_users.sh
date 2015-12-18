#!/bin/bash

# Start MySQL
/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MySQL service startup"
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
done

# Create Admin user
PASS=${MYSQL_PASS:-$(pwgen -s 12 1)}
_word=$( [ ${MYSQL_PASS} ] && echo "preset" || echo "random" )
echo "=> Creating MySQL admin user with ${_word} password"

mysql -uroot -e "CREATE USER 'admin'@'%' IDENTIFIED BY '$PASS'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION"


echo "=> Done!"

echo "========================================================================"
echo "You can now connect to this MySQL Server using:"
echo ""
echo "    mysql -uadmin -p$PASS -h<host> -P<port>"
echo ""
echo "Please remember to change the above password as soon as possible!"
echo "MySQL user 'root' has no password but only allows local connections"
echo "========================================================================"

# If not supplied, generate a random password for the joomla MySQL user.
JOOMLA_PASSWORD=${JOOMLA_PASS:-$(pwgen -s 12 1)}

# Create Joomla user
echo
echo "=> Creating MySQL joomla user"
echo

echo "========================================================================"
echo
echo "MySQL joomla user password:" $JOOMLA_PASSWORD
echo
echo "========================================================================"

# Create Joomla database
echo "=> Creating database joomla in MySQL"

mysql -uroot -e "CREATE DATABASE joomla; \
      GRANT ALL PRIVILEGES ON joomla.* TO 'joomla'@'localhost' \
      IDENTIFIED BY '$JOOMLA_PASSWORD'; FLUSH PRIVILEGES;"

mysqladmin -uroot shutdown
