FROM amazonlinux:2

# Install Apache and PHP
RUN yum update -y && \
    yum install -y httpd php php-mysqlnd php-gd php-xml php-mbstring && \
    yum clean all
    
# Create a test index.html
RUN echo "<html><body><h1>It works!</h1></body></html>" > /var/www/html/index.html

# Configure Apache
RUN echo "ServerName localhost" >> /etc/httpd/conf/httpd.conf && \
    echo "Listen 0.0.0.0:80" >> /etc/httpd/conf/httpd.conf

# Set permissions
RUN chown -R apache:apache /var/www/html && \
    chmod -R 755 /var/www/html

EXPOSE 80

# Start Apache in foreground
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
