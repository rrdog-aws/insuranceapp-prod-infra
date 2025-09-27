FROM amazonlinux:2

# Install Apache and PHP
RUN yum update -y && \
    yum install -y httpd php php-mysqlnd php-gd php-xml php-mbstring && \
    yum clean all

# Remove default index.html if it exists
RUN rm -f /var/www/html/index.html

# Copy the application files
COPY app/index.php /var/www/html/index.php

# Configure Apache to use index.php as default
RUN echo "DirectoryIndex index.php index.html" >> /etc/httpd/conf/httpd.conf

# Configure Apache
RUN echo "ServerName localhost" >> /etc/httpd/conf/httpd.conf && \
    echo "Listen 80" >> /etc/httpd/conf/httpd.conf

# Set permissions
RUN chown -R apache:apache /var/www/html && \
    chmod -R 755 /var/www/html

EXPOSE 80

# Start Apache in foreground
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
