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

dnf install golang -y &>> LOGFILE

useradd roboshop &>> LOGFILE

mkdir /app 

curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch-v3.zip &>> LOGFILE
cd /app 
unzip /tmp/dispatch.zip

cd /app 
go mod init dispatch
go get 
go build

cp path to dispatch.service /etc/systemd/system/dispatch.service  &>> LOGFILE

systemctl daemon-reload

systemctl enable dispatch &>> LOGFILE
systemctl start dispatch &>> LOGFILE



