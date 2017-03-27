FROM php:7.1.3-apache
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

RUN apt-get install -y \
libfreetype6-dev \
libjpeg62-turbo-dev \
libmcrypt-dev \
libpng12-dev \
libsqlite3-dev \
libcurl4-gnutls-dev \
&& apt-get install git -y \
&& apt-get install -y libmcrypt-dev \
&& docker-php-ext-install -j$(nproc) iconv mcrypt pdo_mysql zip opcache mbstring curl\
&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
&& docker-php-ext-enable iconv mcrypt pdo_mysql zip curl opcache mbstring \
&& apt-get autoremove -y

RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

RUN apt-get update && apt-get install -y libmagickwand-6.q16-dev --no-install-recommends \
&& ln -s /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/MagickWand-config /usr/bin \
&& pecl install imagick \
&& echo "extension=imagick.so" > /usr/local/etc/php/conf.d/ext-imagick.ini

RUN apt-get install -y supervisor

COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY conf/apache2.sh /usr/bin/

COPY conf/apache2.conf /etc/apache2/apache2.conf

RUN apache2.sh

EXPOSE 80 443

CMD ["/usr/bin/supervisord"]
