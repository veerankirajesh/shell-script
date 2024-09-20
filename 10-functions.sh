#!/bin/bash
ID=$(id -u)
VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo "ERROR:: $2 ..FAILDED"
        exit 1
    ele    
        echo "$2 ..SUCCESS"

}