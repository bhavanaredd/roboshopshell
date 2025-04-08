#!bin/bash

id=$(id -u)

TIMESTAMP=$(date +%F-%H-%M-%S)

R="\e[31m"
G="\e[32m"
N="\e[0m"

LOGFILE="/tmp/$0-$TIMESTAMP.log" ### $0 denotes the script name 

if [ $id -ne 0]
then
    echo "  $R Not Running as root user"
    exit 1
else 
     echo "$G Running as a root user"
fi

Validate(){

    if [$1 -ne 0]
then
    echo -e " $2  $R FAILED $N"
else 
    echo -e " $2 $G SUCCESS $N "
fi

}

dnf install mysql-server -y &>> LOGFILE

Validate "$?" "Installed MSSQL SERVER"

systemctl enable mysqld &>> LOGFILE

Validate "$?" "Enable mysqld"

systemctl start mysqld  &>> LOGFILE

Validate "$?" "Start mysqld"

mysql_secure_installation --set-root-pass RoboShop@1 &>> LOGFILE

Validate "$?" "Chnaged the default root password access"
