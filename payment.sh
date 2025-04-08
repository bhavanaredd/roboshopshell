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

dnf install python3 gcc python3-devel -y &>> LOGFILE

useradd roboshop &>> LOGFILE

mkdir /app &>> LOGFILE

curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment-v3.zip &>> LOGFILE
cd /app 
unzip /tmp/payment.zip

cd /app 
pip3 install -r requirements.txt &>> LOGFILE

cp /home/ec2-user/roboshopshell/payment.service /etc/systemd/system/payment.service &>> LOGFILE

systemctl daemon-reload

systemctl enable payment 
systemctl start payment &>> LOGFILE



