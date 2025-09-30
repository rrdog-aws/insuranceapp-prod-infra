FROM amazonlinux:2

# Install Apache and PHP
RUN amazon-linux-extras enable php7.4
RUN yum clean metadata
RUN yum update -y && \
    yum install -y httpd php php-mysqlnd php-gd php-xml php-mbstring && \
    yum clean all

# Copy the application file directly to web root
COPY app/index.php /var/www/html/index.php

# Verify files are copied
RUN ls -la /var/www/html/

# Configure Apache
RUN echo "DirectoryIndex index.php index.html" >> /etc/httpd/conf/httpd.conf

# Set permissions
RUN chown -R apache:apache /var/www/html && \
    chmod -R 755 /var/www/html

EXPOSE 80

# Start Apache with verbose logging
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND", "-e", "debug"]