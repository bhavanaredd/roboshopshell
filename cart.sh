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

nf module disable nodejs -y  &>> LOGFILE

Validate $? "Disabled Nodejs"

dnf module enable nodejs:20 -y  &>> LOGFILE

Validate $? "Enabled Nodejs20"

dnf install nodejs -y  &>> LOGFILE

Validate $? "Enabled Nodejs20"

useradd roboshop &>> LOGFILE

Validate $? "Roboshop user added"

mkdir /app 

curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip

cd /app 

unzip /tmp/cart.zip &>> LOGFILE

npm install &>> LOGFILE

cp /home/ec2-user/roboshopshell/cart.service /etc/systemd/system/cart.service

Validate $? "cart service is added"

systemctl daemon-reload

systemctl enable cart

systemctl start cart &>> LOGFILE

Validate $? "cart started"
