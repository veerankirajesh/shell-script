#!/bin/bash
ID=$(id -u)
if [ $ID -ne 0 ]
then
    echo "ERROR:: please run this script with root access"
    exit 1 # you can give other than 0
else
    echo "you are root user"
fi # fi means conditions end
yum install mysql -y
if [ $? -ne 0 ]
then
    echo "ERROR:: installing mysql is faild"
    exit 1
else
    echo "installing mysql is success"
fi
yum install git -y
if [ $? -ne 0 ]
then 
    echo "ERROR:: installing git faild"
    exit 1
else
    echo "installing git success"
fi                 
