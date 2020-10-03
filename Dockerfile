FROM linuxconfig/lamp

# Install prerequisites
RUN apt-get install -y wget php-mbstring

# Download and decompress Mediawiki tarball
RUN wget -qO /tmp/mediawiki.tar.gz https://releases.wikimedia.org/mediawiki/1.35/mediawiki-1.35.0.tar.gz
RUN rm -fr /var/www/html
RUN tar xzf /tmp/mediawiki.tar.gz  -C /var/www/
RUN mv /var/www/mediawiki-* /var/www/html
RUN rm /tmp/mediawiki.tar.gz

# Create database
RUN service mysql start; mysqladmin -uadmin -ppass create mediawiki

# Update file ownership
RUN chown -R www-data.www-data /var/www/html

# Apache configuration
RUN a2enmod rewrite

# Allow ports
EXPOSE 80

CMD ["supervisord"]