# In contruction Docker Evomining using docker image:
========================================
 1 Run evomining image

docker run -i -t -v /home/nelly/GIT/EvoMining/:/var/www/html -p 80:80 newevomining /bin/bash

Database sample
los17
1.1 Start apache

sudo service apache2 start
1.2 Set apache time

file /etc/apache2/apache2.conf
la linea que se cambia
Timeout 300

se cambia por: Timeout 6000000
1.3 Setdatabases

Edit globals $GENOMES="los17"
run reparaheader :walking: perl reparaHEADER.pl
On your browser go to: http://localhost/html/evoMining/indexORIG.html# 
