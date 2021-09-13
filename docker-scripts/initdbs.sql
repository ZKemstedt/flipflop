CREATE DATABASE IF NOT EXISTS Dynmap;
CREATE DATABASE IF NOT EXISTS CoreProtect;


CREATE USER 'pingu'@'localhost' identified by 'skt';
GRANT ALL PRIVILEGES ON *.* TO 'pingu'@'%';