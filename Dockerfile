FROM ubuntu:16.04
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

RUN apt-get upgrade -y

#Install PHP7
RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN apt-get update
RUN apt-get -y --force-yes install php7.0 php7.0-cli php7.0-curl php7.0-intl php7.0-pgsql php7.0-json php7.0-opcache php7.0-mbstring php7.0-xml

#Install curl
RUN apt-get -y install curl

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN php -r "unlink('composer-setup.php');"

RUN apt-get install -y apache2

RUN apt-get install -y supervisor

COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY conf/apache2.sh /usr/bin/

COPY conf/apache2.conf /etc/apache2/apache2.conf

RUN apache2.sh

EXPOSE 80 443

CMD ["/usr/bin/supervisord"]
