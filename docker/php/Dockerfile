FROM php:8.2.12-fpm

LABEL maintainer="OUSSAMA KHACHIAI <oussama.khachiai@gmail.com>"

ARG UID
ARG DEVELOPER_EMAIL
ARG DEVELOPER_NAME

# Create user with same permissions as host and some useful stuff
RUN adduser -u ${UID} --disabled-password --gecos "" webapp
RUN mkdir /home/webapp/.ssh
RUN chown -R webapp:webapp /home/webapp/
RUN echo "StrictHostKeyChecking no" >> /home/webapp/.ssh/config
RUN echo "export COLUMNS=300" >> /home/webapp/.bashrc
RUN echo "alias sf=/var/app/current/bin/console" >> /home/webapp/.bashrc

# Install packages and PHP extensions
RUN apt update \
    # common libraries and extensions
    && apt install -y git acl openssl openssh-client wget zip \
    && apt install -y libpng-dev zlib1g-dev libzip-dev libxml2-dev libicu-dev \
    && docker-php-ext-install intl pdo zip bcmath sockets \
    # for MySQL
    && docker-php-ext-install pdo_mysql \
    && apt install -y vim libssh-dev \
    # APCu
    && pecl install apcu \
    # enable Docker extensions
    && docker-php-ext-enable --ini-name 05-opcache.ini opcache apcu

# Install and update composer
RUN curl https://getcomposer.org/composer.phar -o /usr/bin/composer && chmod +x /usr/bin/composer
RUN composer self-update

## Install Symfony binary
USER webapp
RUN wget https://get.symfony.com/cli/installer -O - | bash
USER root

# for symfony >= 5
RUN mv /home/webapp/.symfony5/bin/symfony /usr/local/bin/symfony

RUN mkdir /.symfony5
RUN mkdir /.composer

# Install PHP-CS-FIXER
RUN wget https://cs.symfony.com/download/php-cs-fixer-v2.phar -O php-cs-fixer
RUN chmod a+x php-cs-fixer
RUN mv php-cs-fixer /usr/local/bin/php-cs-fixer

RUN mkdir -p /var/app

RUN git config --global user.email "${DEVELOPER_EMAIL}"
RUN git config --global user.name "${DEVELOPER_NAME}"

WORKDIR /var/app/current

EXPOSE 9001
