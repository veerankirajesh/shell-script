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

# Install required utils
dnf install -y dnf-utils curl

VALIDATE $? "Installed dnf utils"

# Add Docker repo for RHEL
dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

VALIDATE $? "Added Docker repo"

# Install Docker Engine + Compose plugin
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

VALIDATE $? "Installed Docker components"

# Start and enable Docker
systemctl start docker
VALIDATE $? "Started Docker"

systemctl enable docker
VALIDATE $? "Enabled Docker"

# Add current user to docker group (replace 'centos' with $USER if needed)
usermod -aG docker $USER
VALIDATE $? "Added $USER user to Docker group"

# Check docker-compose plugin
docker compose version
VALIDATE $? "Installed Docker Compose (plugin)"

echo -e "$Y Logout and login again to apply docker group changes $N"
