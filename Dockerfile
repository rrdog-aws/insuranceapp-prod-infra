FROM amazonlinux:2

# Install Apache and PHP
RUN yum update -y && \
    yum install -y httpd php php-mysqlnd php-gd php-xml php-mbstring && \
    yum clean all

# Create app directory
RUN mkdir -p /var/www/html/app

# Copy the application files
COPY app/ /var/www/html/app/

# Verify files are copied (this will show in build logs)
RUN ls -la /var/www/html/app/

# Set index.php as DirectoryIndex and configure Apache
RUN echo "DirectoryIndex index.php index.html" >> /etc/httpd/conf/httpd.conf && \
    echo "<Directory /var/www/html/app>" >> /etc/httpd/conf/httpd.conf && \
    echo "    Options Indexes FollowSymLinks" >> /etc/httpd/conf/httpd.conf && \
    echo "    AllowOverride All" >> /etc/httpd/conf/httpd.conf && \
    echo "    Require all granted" >> /etc/httpd/conf/httpd.conf && \
    echo "</Directory>" >> /etc/httpd/conf/httpd.conf

# Configure Apache
RUN echo "ServerName *********" >> /etc/httpd/conf/httpd.conf && \
    echo "Listen *******:80" >> /etc/httpd/conf/httpd.conf

# Set permissions
RUN chown -R apache:apache /var/www/html && \
    chmod -R 755 /var/www/html

EXPOSE 80

# Start Apache with verbose logging
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND", "-e", "debug"]
