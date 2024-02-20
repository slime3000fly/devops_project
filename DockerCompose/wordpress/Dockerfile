FROM ubuntu:22.04

# Set timezone
RUN ln -snf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime && echo Europe/Warsaw > /etc/timezone

# Install necessary tools and packages
RUN apt-get update
RUN apt-get install -y apache2 \
                       ghostscript \
                       libapache2-mod-php \
                       php \
                       php-bcmath \
                       php-curl \
                       php-imagick \
                       php-intl \
                       php-json \
                       php-mbstring \
                       php-mysql \
                       php-xml \
                       php-zip \
                       curl

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install WordPress
RUN mkdir -p /srv/www && \
    chown www-data: /srv/www && \
    curl -o /tmp/wordpress.tar.gz -SL https://wordpress.org/latest.tar.gz && \
    tar -xzvf /tmp/wordpress.tar.gz -C /srv/www && \
    rm /tmp/wordpress.tar.gz 

# Copy SSL certificates
COPY ssl /etc/ssl

# Copy Apache configuration file
COPY wordpress.conf /etc/apache2/sites-available/

# Enable WordPress site in Apache
RUN a2ensite wordpress && \
    a2enmod rewrite && \
    a2dissite 000-default && \
    a2ensite default-ssl &&\
    a2enmod ssl && \
    service apache2 start

EXPOSE 80
EXPOSE 443

CMD ["apache2ctl", "-D", "FOREGROUND"]
