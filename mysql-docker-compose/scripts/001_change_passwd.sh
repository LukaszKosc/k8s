#!/usr/bin/env bash
set -Eeo pipefail

echo "ALTER USER 'root'@'localhost' IDENTIFIED BY \"${MYSQL_ROOT_PASSWORD}\";" | mysql --user=${MYSQL_USER} --password=${MYSQL_PASSWORD}
echo "ALTER USER 'root'@'%' IDENTIFIED BY \"${MYSQL_ROOT_PASSWORD}\";" | mysql --user=${MYSQL_USER} --password=${MYSQL_PASSWORD}
echo "FLUSH PRIVILEGES;" | mysql --user=${MYSQL_USER} --password=${MYSQL_PASSWORD}

echo "ALTER USER 'lukasz'@'%' IDENTIFIED BY \"${MYSQL_PASSWORD}\";" | mysql --user=root --password=${MYSQL_ROOT_PASSWORD}
echo "GRANT ALL PRIVILEGES ON *.* TO 'lukasz'@'%' WITH GRANT OPTION;" | mysql --user=root --password=${MYSQL_ROOT_PASSWORD}
echo "FLUSH PRIVILEGES;" | mysql --user=root --password=${MYSQL_ROOT_PASSWORD}
