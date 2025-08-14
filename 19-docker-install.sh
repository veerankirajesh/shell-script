#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$(basename $0)-$TIMESTAMP.log"

echo "Script started executing at $TIMESTAMP" &>> "$LOGFILE"

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$2 ... ${R}FAILED${N}"
        exit 1
    else
        echo -e "$2 ... ${G}SUCCESS${N}"
    fi
}

# Root check
if [ "$ID" -ne 0 ]; then
    echo -e "${R}ERROR:: Please run this script with root access${N}"
    exit 1
else
    echo "You are root user"
fi

# Detect actual username (not root)
USERNAME="${SUDO_USER:-$(logname)}"

# Install required tools
dnf install -y dnf-plugins-core &>> "$LOGFILE"
VALIDATE $? "Installed dnf-plugins-core"

# Add Docker repo
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo &>> "$LOGFILE"
VALIDATE $? "Added Docker repo"

# Install Docker packages
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &>> "$LOGFILE"
VALIDATE $? "Installed Docker components"

# Start and enable Docker
systemctl enable --now docker &>> "$LOGFILE"
VALIDATE $? "Started and enabled Docker"

# Add current user to docker group
usermod -aG docker "$USERNAME" &>> "$LOGFILE"
VALIDATE $? "Added $USERNAME to docker group"

# Install latest standalone docker-compose (optional)
curl -L "https://github.com/docker/compose/releases/download/2.24.6/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose &>> "$LOGFILE"
chmod +x /usr/local/bin/docker-compose
docker compose version &>> "$LOGFILE"
VALIDATE $? "Installed docker compose"

echo -e "${Y}Please logout and login again for group changes to take effect.${N}"
