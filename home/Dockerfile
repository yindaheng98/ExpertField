FROM php:7.4-apache
RUN a2enmod proxy proxy_http
COPY src/ /var/www/html/
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf