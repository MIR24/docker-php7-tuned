FROM ubuntu:16.04
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

RUN apt-get upgrade -y

#Install PHP7
RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN apt-get update
RUN apt-get -y  --allow-unauthenticated install php7.1 php7.1-cli php7.1-curl php7.1-intl php7.1-mysql php7.1-pgsql php7.1-json php7.1-opcache php7.1-mbstring php7.1-xml

#Install curl
RUN apt-get -y install curl

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN php -r "unlink('composer-setup.php');"

RUN apt-get install -y apache2

RUN apt-get install -y supervisor

RUN apt-get -y install git

COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY conf/apache2.sh /usr/bin/

COPY conf/apache2.conf /etc/apache2/apache2.conf

RUN apache2.sh

EXPOSE 80 443

CMD ["/usr/bin/supervisord"]
