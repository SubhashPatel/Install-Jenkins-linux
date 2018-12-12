#!/bin/bash

#######################################
# Bash script to install a Jenkins in ubuntu
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
apt-get install unzip -y

# Install Java if not allready Installed
if java -version | grep -q "java version" ; then
  echo "Java Installed"
else
  sudo add-apt-repository ppa:webupd8team/java -y  && sudo apt-get update -y  && echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections && sudo apt-get install oracle-java8-installer -y && echo JAVA_HOME=/usr/lib/jvm/java-8-oracle >> /etc/environment && echo JRE_HOME=/usr/lib/jvm/java-8-oracle/jre >> /etc/environment && source /etc/environment
fi

# Install Tomcat
cd /opt/
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.8/bin/apache-tomcat-9.0.8.zip
unzip apache-tomcat-9.0.8.zip

# Install Jenkins
cd /opt/
wget http://mirrors.jenkins.io/war/latest/jenkins.war
mv jenkins.war /opt/apache-tomcat-9.0.8/webapps/

# Set Permission for execute
chmod +x /opt/apache-tomcat-9.0.8/bin/*.sh

# Adjust the Firewall
ufw allow 8080/tcp

# Create Service files
cd /etc/systemd/system/
wget https://s3.amazonaws.com/serverkaka-pubic-file/tomcat-ubuntu
mv tomcat-ubuntu jenkins.service

# Start tomcat
sudo systemctl daemon-reload
sudo systemctl start jenkins

# Set auto start tomcat as a system boot
sudo systemctl enable jenkins

# Clean downloades files
rm /opt/apache-tomcat-9.0.8.zip
apt-get autoremove

echo "Jenkins is successfully installed at /opt/apache-tomcat-9.0.8/webapps/jenkins" For Aceess Jenkins Go to http://localhost:8080/jenkins/
echo "you can start and stop Jenkins using command : sudo service jenkins stop|start|status|restart"
