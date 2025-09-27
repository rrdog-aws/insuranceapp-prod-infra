FROM amazonlinux:2

# Install Apache and PHP
RUN yum update -y && \
    yum install -y httpd php php-mysqlnd php-gd php-xml php-mbstring curl && \
    yum clean all

# Remove default index.html if it exists
RUN rm -f /var/www/html/index.html

# Copy the application files
COPY app/index.php /var/www/html/index.php

# Configure Apache
RUN echo "DirectoryIndex index.php index.html" >> /etc/httpd/conf/httpd.conf && \
    echo "ServerName [IP_ADDRESS]" >> /etc/httpd/conf/httpd.conf && \
    echo "Listen 80" >> /etc/httpd/conf/httpd.conf

# Set environment variables
ENV APACHE_RUN_DIR=/var/run/httpd \
    APACHE_RUN_USER=apache \
    APACHE_RUN_GROUP=apache

# Create necessary directories
RUN mkdir -p /var/run/httpd

# Set permissions
RUN chown -R apache:apache /var/www/html && \
    chmod -R 755 /var/www/html

# Add health check
HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://[IP_ADDRESS]:80/ || exit 1

EXPOSE 80

# Start Apache in foreground
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]