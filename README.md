docker.ubuntu-apache-php-perl-mysql_client
========================================

Docker image - ubuntu with apache, perl and mysql client

usage:
 docker build -t="ubuntu-apache-php-perl-mysql_client" .

 docker run -v `pwd`:/var/www/html -p 80:80 -d ubuntu-apache-php-perl-mysql_client
