#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$2 ... $R FAILED $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]; then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1
else
    echo "You are root user"
fi

# Install required tools
dnf install -y dnf-utils

VALIDATE $? "Installed dnf utils"

# Add Docker repository for CentOS Stream 9 (works for RHEL 9)
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

VALIDATE $? "Added Docker repo"

# Install Docker
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

VALIDATE $? "Installed Docker components"

# Start and enable Docker
systemctl start docker
VALIDATE $? "Started Docker"

systemctl enable docker
VALIDATE $? "Enabled Docker"

# Detect the current username (instead of hardcoding 'centos')
CURRENT_USER=$(logname)
usermod -aG docker $CURRENT_USER
VALIDATE $? "Added $CURRENT_USER to Docker group"

# Install latest Docker Compose (standalone binary)
curl -L https://github.com/docker/compose/releases/download/2.24.6/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

docker compose version
VALIDATE $? "Installed Docker Compose"

echo -e "$Y Logout and login again for group changes to take effect $N"
