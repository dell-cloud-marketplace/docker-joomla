# docker-joomla
This image installs [Joomla](http://www.joomla.org/), a popular open-source content management system.

## Components
The stack comprises the following components (some are obtained through [dell/lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base)):

Name       | Version                 | Description
-----------|-------------------------|------------------------------
Joomla	    | 3.3.6                   | Content Management System
Ubuntu     | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base) | Operating system
MySQL      | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base) | Database
Apache     | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base) | Web server
PHP        | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base) | Scripting language

## Usage

### 1. Start the Container
If you wish to create data volumes, which will survive a restart or recreation of the container, please follow the instructions in [Advanced Usage](#advanced-usage).

#### A. Basic Usage
Start your container with:

 - Ports 80, 443 (Apache Web Server) and 3306 (MySQL) exposed
 - A named container (**joomla**)

As follows:

```no-highlight
sudo docker run -d -p 80:80 -p 443:443 -p 3306:3306 --name joomla dell/joomla
```

<a name="advanced-usage"></a>
#### B. Advanced Usage
Start your container with:

* Ports 80, 443 (Apache Web Server) and 3306 (MySQL) exposed
* A named container (**joomla**)
* A predefined password for the MySQL **admin** user
* Two data volumes (which will survive a restart or recreation of the container). The MySQL data is available in **/data/mysql** on the host. The PHP application files are available in **/app** on the host.

```no-highlight
sudo docker run -d \
    -p 80:80 \
    -p 443:443 \
    -p 3306:3306 \
    -v /app:/var/www/html \
    -v /data/mysql:/var/lib/mysql \
    -e MYSQL_PASS="password"  \
    --name joomla \
    dell/joomla
```

### 2. Check the Log Files

If you haven't defined a MySQL password, the container will generate a random one. Check the logs for the password by running: 

```no-highlight
sudo docker logs joomla
```

You will see output like the following:

```no-highlight
========================================================================
You can now connect to this MySQL Server using:

   mysql admin -u admin -pca1w7dUhnIgI --host <host>  -h<host> -P<port>

   Please remember to change the above password as soon as possible!
   MySQL user 'root' has no password but only allows local connections
========================================================================

========================================================================

MySQL user: joomla and password: Me2rae1jiefi

========================================================================
```

Make a secure note of:

* The admin user password (in this case **ca1w7dUhnIgI**)
* The joomla user password (in this case **Me2rae1jiefi**)

Next, test the **admin** user connection to MySQL:

```no-highlight
mysql -uadmin -pca1w7dUhnIgI -h127.0.0.1 -P3306
```

## Complete the Installation
Open a web browser and navigate to either the public DNS or IP address of your instance. For example, if the IP address is 54.75.168.125, do:

```no-highlight
https://54.75.168.125
```

Your browser will warn you that the certificate is not trusted. If you are unclear about how to proceed, please consult your browser's documentation on how to accept the certificate.

You should see Joomla configuration wizard set to the **Configuration** tab. Select your language and supply the requested information for the following fields:

* Site Name
* Admin Email
* Admin Username
* Admin Password
* Site Offline

Click on **Next** to proceed to the **Database Configuration** tab. Supply the following information:

* Database Type: **MySQL**
* Hostname: **localhost**
* Username: **joomla**
* Password: *The joomla password read from the logs.*
* Database Name: **joomla**
* Database prefix : *Choose a table prefix or accept the randomly generated value*
* Old Database Process : **Backup** or **Remove** (if you have a previous Joomla! installation)

Click on **Next** to proceed to the **Overview** tab. Select your preferred sample data and review the configuration set. Once reviewed, you can complete the configuration by clicking on **Install**. On completion, you are requested to remove the installation folder by clicking **Remove installation folder** (this is a security feature and without this you are not able to proceed further).

Next, click on **Site** or **Administrator** to access the newly-created Joomla site.

### Getting Started
If you need assistance with customizing Joomla, the following links might be helpful:

* [Joomla Documentation](http://docs.joomla.org/Main_Page)
* [Getting Started with Joomla](http://docs.joomla.org/Getting_Started_with_Joomla!)
* [Joomla Extensions Directory](http://extensions.joomla.org/)
* [Joomla API](http://api.joomla.org/)

### Image Details
Pre-built Image | [https://registry.hub.docker.com/u/dell/joomla](https://registry.hub.docker.com/u/dell/joomla)
