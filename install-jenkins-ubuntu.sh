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
echo [Unit] >> /etc/systemd/system/tomcat.service
echo Description=Tomcat 9 servlet container >> /etc/systemd/system/tomcat.service
echo After=network.target >> /etc/systemd/system/tomcat.service
echo  >> /etc/systemd/system/tomcat.service
echo [Service] >> /etc/systemd/system/tomcat.service
echo Type=forking >> /etc/systemd/system/tomcat.service
echo  >> /etc/systemd/system/tomcat.service
echo User=root >> /etc/systemd/system/tomcat.service
echo Group=root >> /etc/systemd/system/tomcat.service
echo  >> /etc/systemd/system/tomcat.service
echo Environment="JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> /etc/systemd/system/tomcat.service
echo Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom -Djava.awt.headless=true" >> /etc/systemd/system/tomcat.service
echo  >> /etc/systemd/system/tomcat.service
echo Environment="CATALINA_BASE=/opt/apache-tomcat-9.0.8" >> /etc/systemd/system/tomcat.service
echo Environment="CATALINA_HOME=/opt/apache-tomcat-9.0.8" >> /etc/systemd/system/tomcat.service
echo Environment="CATALINA_PID=/opt/apache-tomcat-9.0.8/temp/tomcat.pid" >> /etc/systemd/system/tomcat.service
echo Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC" >> /etc/systemd/system/tomcat.service
echo  >> /etc/systemd/system/tomcat.service
echo ExecStart=/opt/apache-tomcat-9.0.8/bin/startup.sh >> /etc/systemd/system/tomcat.service
echo ExecStop=/opt/apache-tomcat-9.0.8/bin/shutdown.sh >> /etc/systemd/system/tomcat.service
echo  >> /etc/systemd/system/tomcat.service
echo [Install] >> /etc/systemd/system/tomcat.service
echo WantedBy=multi-user.target >> /etc/systemd/system/tomcat.service

# Start tomcat
sudo systemctl daemon-reload
sudo systemctl start tomcat

# Set auto start tomcat as a system boot
sudo systemctl enable tomcat

# Clean downloades files
rm /opt/apache-tomcat-9.0.8.zip
apt-get autoremove

echo "Jenkins is successfully installed at /opt/apache-tomcat-9.0.8/webapps/jenkins" For Aceess tomcat Go to http://localhost:8080/jenkins/
echo "you can start and stop jenkins using command : sudo service tomcat stop|start|status|restart"
