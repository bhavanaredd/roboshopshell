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

dnf module disable redis -y &>> LOGFILE

Validate "$?" "Disabled redis"

dnf module enable redis:7 -y &>> LOGFILE

Validate "$?" "Enabled redis"

dnf install redis -y  &>> LOGFILE

Validate "$?" "Install redis"

cp /etc/redis/redis.conf /etc/redis/redis.conf.bak  &>> LOGFILE

Validate "$?" "Copied Backup"

sed -i 's/^bind 127.0.0.1/bind 0.0.0.0/' /etc/redis/redis.conf  &>> LOGFILE

Validate "$?" "Changed IP Adress"

sed -i 's/^protected-mode yes/protected-mode no/' /etc/redis/redis.conf  &>> LOGFILE

Validate "$?" "Changed Protected Mode"

systemctl enable redis  &>> LOGFILE

Validate "$?" "Enable redis"

systemctl start redis  &>> LOGFILE

Validate "$?" "Start redis"



