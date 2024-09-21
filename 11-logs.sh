#!/bin/bash
ID=$(id -u)
TIMESTAMP=$(date+%F-%H-%M-%-S)
R="/e[31m"
G="/e[32m"
N="/e[0m"
LOGFILE="/tmp/&0-&TIMESTAMP.LOG"
echo "script started executing at $ TIMESTAMP"&>> $ LOGFILE
VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo "ERROR:: $2 ... FAILED"
        exit 1
    else
        echo "$2 ... SUCCESS"
    fi
}

if [ $ID -ne 0 ]
then
    echo "ERROR:: Please run this script with root access"
    exit 1 # you can give other than 0
else
    echo "You are root user"
fi # fi means reverse of if, indicating condition end
yum install mysql -y &>> $ LOGFILE
VALIDATE $? "Installing MySQL"
yum install git -y &>> $ LOGFILE
VALIDATE $? "Installing GIT"