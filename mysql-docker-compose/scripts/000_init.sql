use mysql;

DROP USER IF EXISTS 'lukasz'@'localhost';
FLUSH PRIVILEGES;

CREATE USER 'lukasz'@'localhost' IDENTIFIED BY 'Password123!';
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'lukasz'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;

DROP DATABASE IF EXISTS mydb;
CREATE DATABASE IF NOT EXISTS mydb;

use mydb;
DROP TABLE IF EXISTS testowa;
CREATE TABLE IF NOT EXISTS testowa (id int not null auto_increment primary key, name varchar(30), present boolean not null, note text);
commit;