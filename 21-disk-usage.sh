#!/bin/bash

DISK_USAGE=$(df -hT | grep -v Filesystem)
DISK_THRESHOLD=1   # in project use 75
MSG=""
IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

while IFS= read -r line
do
    USAGE=$(echo $line | awk '{print $6}' | cut -d "%" -f1)
    PARTITION=$(echo $line | awk '{print $7}')
    if [ "$USAGE" -ge "$DISK_THRESHOLD" ]
    then
        MSG+="High Disk Usage on $PARTITION: $USAGE % <br>"
    fi
done <<< "$DISK_USAGE"

# Debug check
# echo -e "$MSG"

sh mail.sh "DevOps Team" "High Disk Usage" "$IP" "$MSG" "rajeshveeranki478@gmail.com" "ALERT-High Disk Usage"
