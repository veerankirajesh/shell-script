#!/bin/bash

# -------------------------
# Color Codes
# -------------------------
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$(basename $0)-$TIMESTAMP.log"

echo "Script started executing at $TIMESTAMP" &>> "$LOGFILE"

# -------------------------
# Function to validate last command
# -------------------------
VALIDATE() {
    if [ $1 -ne 0 ]; then
        echo -e "$2 ... ${R}FAILED${N}"
        exit 1
    else
        echo -e "$2 ... ${G}SUCCESS${N}"
    fi
}

# -------------------------
# Root user check
# -------------------------
if [ "$ID" -ne 0 ]; then
    echo -e "${R}ERROR:: Please run this script with root access${N}"
    exit 1
else
    echo "You are root user"
fi

# -------------------------
# Detect OS version
# -------------------------
if [ -f /etc/redhat-release ]; then
    OS_VERSION=$(rpm -E %{rhel})
else
    echo -e "${R}ERROR: This script is for RHEL/CentOS only.${N}"
    exit 1
fi

if [ "$OS_VERSION" -ne 9 ]; then
    echo -e "${R}ERROR: This script is only for RHEL 9.${N}"
    exit 1
fi

echo "Detected RHEL version: $OS_VERSION"

# -------------------------
# Remove any old Docker versions
# -------------------------
echo "Removing old Docker versions..." &>> "$LOGFILE"
dnf remove -y docker docker-client docker-client-latest docker-common \
    docker-latest docker-latest-logrotate docker-logrotate docker-engine &>> "$LOGFILE"

# -------------------------
# Enable CRB repo (needed for some Docker deps)
# -------------------------
dnf config-manager --set-enabled crb &>> "$LOGFILE"
VALIDATE $? "Enabled CRB repository"

# -------------------------
# Install required tools & add Docker repo
# -------------------------
dnf install -y dnf-plugins-core &>> "$LOGFILE"
VALIDATE $? "Installed dnf-plugins-core"

dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo &>> "$LOGFILE"
VALIDATE $? "Added Docker repo"

# -------------------------
# Install Docker
# -------------------------
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &>> "$LOGFILE"
VALIDATE $? "Installed Docker components"

# -------------------------
# Start and enable Docker
# -------------------------
systemctl enable --now docker &>> "$LOGFILE"
VALIDATE $? "Started and enabled Docker"

# -------------------------
# Add current user to docker group
# -------------------------
USERNAME="${SUDO_USER:-$(logname)}"
usermod -aG docker "$USERNAME" &>> "$LOGFILE"
VALIDATE $? "Added $USERNAME to docker group"

# -------------------------
# Verify Docker compose plugin
# -------------------------
docker compose version &>> "$LOGFILE"
VALIDATE $? "Verified docker compose plugin"

# -------------------------
# Test Docker installation
# -------------------------
docker run --rm hello-world &>> "$LOGFILE" || echo -e "${Y}Docker installed but hello-world test skipped (no internet).${N}"

# -------------------------
# Cleanup
# -------------------------
dnf clean all &>> "$LOGFILE"

echo -e "${Y}Please logout and login again for group changes to take effect.${N}"
