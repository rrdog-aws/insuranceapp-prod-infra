FROM amazonlinux:2

# Install Apache and PHP
RUN yum update -y && \
    yum install -y httpd php php-mysqlnd php-gd php-xml php-mbstring && \
    yum clean all

# Create app directory
RUN mkdir -p /var/www/html/app

# Copy the application files
COPY app/ /var/www/html/app/

# Set index.php as DirectoryIndex
RUN sed -i 's|DocumentRoot "/var/www/html"|DocumentRoot "/var/www/html/app"|g' /etc/httpd/conf/httpd.conf
RUN echo "DirectoryIndex index.php index.html" >> /etc/httpd/conf/httpd.conf
RUN cat /etc/httpd/conf/httpd.conf
RUN ls /var/www/html/app/

# Configure Apache
RUN echo "ServerName *********" >> /etc/httpd/conf/httpd.conf && \
    echo "Listen *******:80" >> /etc/httpd/conf/httpd.conf

# Set permissions
RUN chown -R apache:apache /var/www/html && \
    chmod -R 755 /var/www/html

EXPOSE 80

# Start Apache in foreground
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
