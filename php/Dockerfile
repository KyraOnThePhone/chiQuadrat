FROM namoshek/php-mssql:8.3-cli-alpine

USER root


RUN docker-php-ext-install session
RUN apk update && apk add --no-cache apache2 apache2-utils php php-apache2 php-mysqli php-pdo_mysql php-json php-opcache php83-pear php83-xml
RUN apk add php-session
RUN apk add --no-cache msodbcsql18



RUN apk add --no-cache unixodbc unixodbc-dev
RUN apk add make gcc g++ autoconf libc-dev unixodbc-dev
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && echo "https://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
RUN apk update && apk add php php83-cli php83-dev php83-pear php83-common php83-pdo php83-session unixodbc-dev
RUN curl -o /etc/apk/keys/microsoft.asc https://packages.microsoft.com/keys/microsoft.asc
RUN apk add --no-cache msodbcsql18


  RUN echo "extension_dir = \"/usr/local/lib/php/extensions/no-debug-non-zts-20230831\"" >> /etc/php83/php.ini

RUN echo "LoadModule php_module modules/libphp.so" >> /etc/apache2/httpd.conf \
  && echo "AddHandler php-script .php" >> /etc/apache2/httpd.conf \
  && echo "DirectoryIndex index.php index.html" >> /etc/apache2/httpd.conf

CMD ["/bin/sh", "-c", "httpd -D FOREGROUND"]