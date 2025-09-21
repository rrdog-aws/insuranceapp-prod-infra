FROM amazonlinux:2

# Install Apache and PHP
RUN yum update -y && \
    yum install -y httpd php php-mysqlnd php-gd php-xml php-mbstring && \
    yum clean all

# Copy application code
COPY app/ /var/www/html/

# Set permissions
RUN chown -R apache:apache /var/www/html && \
    chmod -R 755 /var/www/html

# Expose port 80
EXPOSE 80

# Start Apache in foreground
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
