FROM php:8.0-apache

WORKDIR /var/www/html
EXPOSE 80

RUN apt update -y \
    && apt upgrade -y \
    && apt install -y \
    libreoffice-common libreoffice-java-common \
    clamav \
    unoconv \
    default-jre \
    imagemagick ffmpeg tesseract-ocr \
    meshlab dia pandoc \
    poppler-utils nodejs gnuplot \
    libnode-dev node-gyp \
    # Clean
    && apt clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html/HRProprietary/HRConvert2/Logs \
    && mkdir /home/converter \
    && chmod -R 0755 /home/converter \
    && chown -R www-data:www-data /home/converter

COPY .  .
COPY rc.local /etc/rc.local
RUN chmod +x /etc/rc.local

RUN chmod -R 0755 /var/www/html \
    && chown -R www-data:www-data /var/www/html

ENV APACHE_RUN_USER  www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR   /var/log/apache2
ENV APACHE_PID_FILE  /var/run/apache2/apache2.pid
ENV APACHE_RUN_DIR   /var/run/apache2
ENV APACHE_LOCK_DIR  /var/lock/apache2
ENV APACHE_LOG_DIR   /var/log/apache2

ENTRYPOINT ["apache2-foreground"]

