#!/bin/bash
ID=$(id -u)
if [ $ID -ne 0 ]
then
    echo "ERROR::please run this root access"
    exit 1
else
    echo "are you root user"
fi
yum install mysql -y
if [ $? -ne 0 ]
then
    echo "ERROR::mysql installed failed"
    exit 1
else
    echo "MYSQL installed success"
fi    
yum install git -y
if [ $? -ne 0 ]
then
    echo "ERROR::git installed failed"
    exit 1
else
    echo "GIT installed success"
fi        