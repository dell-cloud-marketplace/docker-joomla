FROM dell/lamp-base:1.0
MAINTAINER Dell Cloud Market Place <Cloud_Marketplace@dell.com>

# Install packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install unzip

# Download Joomla
ADD https://github.com/joomla/joomla-cms/releases/\
download/3.3.6/Joomla_3.3.6-Stable-Full_Package.zip /tmp/

# Remove previous files
RUN rm -rf /var/www/html/*

# Extract Joomla
RUN \
  cd /tmp && ls -la && \
  unzip -d /tmp/joomla/ Joomla_3.3.6-Stable-Full_Package.zip && \
  rm Joomla_3.3.6-Stable-Full_Package.zip

# Add scripts and make them executable.
ADD create_mysql_users.sh /create_mysql_users.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh

# Add volumes for MySQL and application.
VOLUME ["/var/lib/mysql", "/var/www/html"]

# Expose ports
EXPOSE 80 3306 443

CMD ["/run.sh"]
