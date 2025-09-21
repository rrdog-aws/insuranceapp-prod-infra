FROM amazonlinux:2

# Install EPEL repository
RUN amazon-linux-extras install epel -y

# Install Nginx and PHP
RUN amazon-linux-extras enable nginx1 php8.2 && \
    yum clean metadata && \
    yum install -y \
    nginx \
    php \
    php-fpm \
    php-mysqlnd \
    php-gd \
    php-xml \
    php-mbstring \
    php-zip \
    php-json \
    php-pdo \
    php-common \
    && yum clean all \
    && rm -rf /var/cache/yum

# Create necessary directories
RUN mkdir -p /run/php-fpm && \
    mkdir -p /var/www/html

# Copy application code
COPY app/ /var/www/html/

# Copy configuration files
COPY config/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY config/php/www.conf /etc/php-fpm.d/www.conf

# Set permissions
RUN chown -R nginx:nginx /var/www/html && \
    chmod -R 755 /var/www/html

# Configure PHP
RUN echo "date.timezone = UTC" >> /etc/php.ini && \
    echo "memory_limit = 128M" >> /etc/php.ini && \
    echo "max_execution_time = 30" >> /etc/php.ini

# Forward logs to stdout/stderr
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

# Expose port 80
EXPOSE 80

# Copy the entrypoint script
COPY config/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

# Start Nginx and PHP-FPM
ENTRYPOINT ["/docker-entrypoint.sh"]
