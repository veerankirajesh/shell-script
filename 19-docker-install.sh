#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/${0##*/}-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE() {
    if [ $1 -ne 0 ]; then
        echo -e "$2 ... ${R}FAILED${N}"
        exit 1
    else
        echo -e "$2 ... ${G}SUCCESS${N}"
    fi
}

if [ $ID -ne 0 ]; then
    echo -e "${R}ERROR:: Please run this script with root access${N}"
    exit 1
else
    echo "You are root user"
fi

# Remove old Docker versions
dnf remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine &>> $LOGFILE

# Install required plugin tools
dnf install -y dnf-plugins-core &>> $LOGFILE
VALIDATE $? "Installed dnf plugins core"

# Add Docker repository for RHEL 9
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo &>> $LOGFILE
VALIDATE $? "Added Docker repo"

# Install Docker
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &>> $LOGFILE
VALIDATE $? "Installed Docker components"

# Start and enable Docker
systemctl enable --now docker &>> $LOGFILE
VALIDATE $? "Started and enabled Docker"

# Detect username for Docker group
CURRENT_USER=${SUDO_USER:-$(logname)}
usermod -aG docker "$CURRENT_USER" &>> $LOGFILE
VALIDATE $? "Added $CURRENT_USER to Docker group"

# Install latest Docker Compose
COMPOSE_VERSION="2.24.6"
curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose &>> $LOGFILE
chmod +x /usr/local/bin/docker-compose
docker compose version &>> $LOGFILE
VALIDATE $? "Installed Docker Compose"

echo -e "${Y}Logout and login again for group changes to take effect${N}"
