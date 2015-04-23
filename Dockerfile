FROM dell/lamp-base:1.1
MAINTAINER Dell Cloud Market Place <Cloud_Marketplace@dell.com>

# Update existing packages.
RUN apt-get update 

# Install packages
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get -y install \
        unzip
RUN apt-get -y clean

# Download Joomla
ADD https://github.com/joomla/joomla-cms/releases/\
download/3.4.1/Joomla_3.4.1-Stable-Full_Package.zip /tmp/

# Remove previous files
RUN rm -rf /var/www/html/*

# Extract Joomla
RUN \
  cd /tmp && ls -la && \
  unzip -d /tmp/joomla/ Joomla_3.4.1-Stable-Full_Package.zip && \
  rm Joomla_3.4.1-Stable-Full_Package.zip

# Add scripts and make them executable.
COPY create_mysql_users.sh /create_mysql_users.sh
COPY run.sh /run.sh
RUN chmod +x /*.sh

# Add volumes for MySQL and application.
VOLUME ["/var/lib/mysql", "/var/www/html"]

# Expose ports
EXPOSE 80 3306 443

CMD ["/run.sh"]
