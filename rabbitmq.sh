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

cp /home/ec2-user/roboshopshell/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>> LOGFILE

Validate "$?" "Copied repo"

dnf install rabbitmq-server -y &>> LOGFILE

Validate "$?" "Installed rabbitmq"

systemctl enable rabbitmq-server &>> LOGFILE

Validate "$?" "enable rabbitmq"

systemctl start rabbitmq-server &>> LOGFILE

Validate "$?" "Start rabbitmq"

rabbitmqctl add_user roboshop roboshop123 &>> LOGFILE

Validate "$?" "Add rabbitmq user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> LOGFILE

Validate "$?" "set permissions for rabbitmq user"



