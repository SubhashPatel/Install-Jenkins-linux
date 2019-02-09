#!/bin/bash

#######################################
# Bash script to create Backup of Jenkins in ubuntu
# Author: Subhash (serverkaka.com)

# Check if running as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

read -p 'Give me JENKINS_HOME directory [/root/.jenkins]: ' JENKINS_HOME

# check if JENKINS_HOME directory is available or not
if [ -d $JENKINS_HOME ]
then 
    echo "dir $JENKINS_HOME present"
else
    echo "$JENKINS_HOME dir not present"
	exit 1
fi

# Prerequisite
apt-get install zip -y

# Create Backup
cd $JENKINS_HOME
JD=${PWD##*/}
cd ..
BD=${PWD}
zip -rv jenkins.zip $JD

echo Jenkins Backup is successfully completed. Backup file is $BD/jenkins.zip
