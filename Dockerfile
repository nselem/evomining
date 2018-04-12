FROM ubuntu:14.04

MAINTAINER Jindrich Vimr <jvimr@softeu.com>

RUN echo "1.565.1" > .lts-version-number

RUN apt-get update && apt-get install -y wget git curl zip vim
RUN apt-get update && apt-get install -y apache2 php5 perl libapache2-mod-perl2 php5-mysql libdbd-mysql-perl libdatetime-format-builder-perl libemail-abstract-perl libemail-send-perl libemail-simple-perl libemail-mime-perl libtemplate-perl libmath-random-isaac-perl libgd-text-perl libgd-graph-perl libxml-twig-perl libchart-perl libnet-ldapapi-perl libtemplate-plugin-gd-perl  libfile-slurp-perl libhtml-scrubber-perl libhtml-formattext-withlinks-perl libjson-rpc-perl libjson-xs-perl libnet-ldap-perl libauthen-radius-perl libencode-detect-perl libfile-mimeinfo-perl libio-stringy-perl libdaemon-generic-perl

RUN apt-get update && apt-get install -y php5-intl imagemagick
RUN usermod -U www-data && chsh -s /bin/bash www-data
RUN a2enmod rewrite cgi perl headers

volume "/var/log"
ENV SERVER_NAME docker-apache-php
# for main web interface:
EXPOSE 80


## Installing perl module
RUN apt-get install make && curl -L http://cpanmin.us | perl - App::cpanminus
RUN cpanm SVG
RUN cpanm Statistics::Basic

###____________________________________________

RUN if [ ! -d /opt ]; then mkdir /opt; fi
###__________________________________________________________________________________________________________________________________
# Installing blast

RUN mkdir /opt/blast && curl ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.30/ncbi-blast-2.2.30+-x64-linux.tar.gz | tar -zxC /opt/blast --strip-components=1

######___________________________________________________________________________________________________________________________________
# Instaling muscle
 RUN wget -O /opt/muscle3.8.tar.gz http://www.drive5.com/muscle/downloads3.8.31/muscle3.8.31_i86linux64.tar.gz
 RUN mkdir /opt/muscle && tar -C /opt/muscle -xzvf /opt/muscle3.8.tar.gz && ln -s /opt/muscle/muscle3.8.31_i86linux64 /opt/muscle/muscle  
####___________________________________________________________________________________________________________________________________
# Installing GBlocks
RUN curl -SL http://molevol.cmima.csic.es/castresana/Gblocks/Gblocks_Linux64_0.91b.tar.Z | tar -xzC /opt 
####___________________________________________________________________________________________________________________________________
RUN apt-get install -y build-essential
## Instaling Quicktree
RUN wget -O /opt/quicktree.tar.gz ftp://ftp.sanger.ac.uk/pub/resources/software/quicktree/quicktree.tar.gz 
RUN mkdir /opt/quicktree && tar -C /opt/quicktree -zxvf /opt/quicktree.tar.gz && cd /opt/quicktree/quicktree_1.1 &&  make quicktree
#___________________________________________________________________________________________________________________________________

# Installing NewickTools
RUN wget -O /opt/newick-utils-1.6.tar.gz http://cegg.unige.ch/pub/newick-utils-1.6-Linux-x86_64-disabled-extra.tar.gz 
RUN mkdir /opt/nw && tar -C /opt/nw -xzvf /opt/newick-utils-1.6.tar.gz && cd /opt/nw/newick-utils-1.6 && cp src/nw_* /usr/local/bin

#_________________________________________________________________________________________________



WORKDIR /var/www/
#RUN mkdir /var/www/html
RUN chmod -R 777 /var/www/html

## EvoMining
 ######### PATHS ENVIRONMENT
ENV PATH /opt/blast/bin:$PATH:/opt/muscle:/opt/quicktree/quicktree_1.1/bin
RUN git clone https://github.com/nselem/EvoMining /var/www/html/EvoMining
RUN chmod -R 777 /var/www/html/EvoMining
RUN mv /var/www/html/EvoMining/enable-var-www-html-htaccess.conf /etc/apache2/conf-enabled/
RUN mv /var/www/html/EvoMining/apache2.conf /etc/apache2/
RUN service apache2 start

RUN cp /opt/Gblocks_0.91b/Gblocks /var/www/html/EvoMining/cgi-bin/.
RUN cpanm IO::Tee
RUN cpanm Bio::SeqIO
WORKDIR /var/www/html/EvoMining/cgi-bin
#COPY . /var/www/html
CMD ["perl", "/var/www/html/EvoMining/cgi-bin/startEvoMining.pl"]
