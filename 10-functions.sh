#!/bin/bash
ID=(id -u)
VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo "ERROR::$2 ..falied"
        exit 1
    else
        echo "$1 .. success "
    fi        
}
fi [ $ID - ne 0 ]
then
    echo "ERROR::please run this root acess"
    exit 1
else
    echo "you are root user"
fi
yum install mysql -y
VALIDATE $? "installing MYSQL"
yum install git -y
VALIDATE $? "installing GIT"

