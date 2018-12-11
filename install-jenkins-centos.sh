#!/bin/bash

#######################################
# Bash script to install a Jenkins in CentOS
# Author: Subhash (serverkaka.com)

# Check if running as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Check port 8080 is Free or Not
netstat -ln | grep ":8080 " 2>&1 > /dev/null
if [ $? -eq 1 ]; then
     echo go ahead
else
     echo Port 8080 is allready used
     exit 1
fi

# Prerequisite
yum install wget unzip -y

# Install Java if not allready Installed
if java -version | grep -q "java version" ; then
  echo "Java Installed"
else
	sudo yum install java-1.8.0-openjdk-devel -y
fi

# Install Tomcat
cd /opt/
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.8/bin/apache-tomcat-9.0.8.zip
unzip apache-tomcat-9.0.8.zip

# Install Jenkins
cd /opt/
wget http://mirrors.jenkins.io/war/latest/jenkins.war
mv jenkins.war /opt/apache-tomcat-9.0.8/webapps/

# Adjust the Firewall
firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --reload

# Create Service files
cd /etc/init.d/
wget https://s3.amazonaws.com/serverkaka-pubic-file/tomcat-centos
mv tomcat-centos jenkins
sed -i -e 's/\r//g' /etc/init.d/jenkins

# Set Permission for execute
chmod +x /opt/apache-tomcat-9.0.8/bin/*.sh
chmod +x /etc/init.d/jenkins

# Start tomcat
service jenkins start

# Set auto start tomcat as a system boot
service tomcat enable

# Clean downloades files
rm /opt/apache-tomcat-9.0.8.zip
yum autoremove

echo "Jenkins is successfully installed at /opt/apache-tomcat-9.0.8" For Aceess jomcat Go to http://localhost:8080/jenkins/
echo "you can start and stop jenkins using command : sudo service tomcat stop|start|status|restart"
