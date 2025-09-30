FROM amazonlinux:2

# Install Apache and PHP
RUN amazon-linux-extras enable php7.4
RUN yum clean metadata
RUN yum update -y && \
    yum install -y httpd php php-mysqlnd php-gd php-xml php-mbstring && \
    yum clean all


# Create app directory
RUN mkdir -p /var/www/html/app

# Copy the application files
COPY app/ /var/www/html/app/index.php

# Verify files are copied (this will show in build logs)
RUN ls -la /var/www/html/

# Set index.php as DirectoryIndex and configure Apache
RUN echo "DirectoryIndex index.php index.html" >> /etc/httpd/conf/httpd.conf
COPY app/index.php /var/www/html/index.php


# Set permissions
RUN chown -R apache:apache /var/www/html && \
    chmod -R 755 /var/www/html

EXPOSE 80

# Start Apache with verbose logging
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND", "-e", "debug"]
