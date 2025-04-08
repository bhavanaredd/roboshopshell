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


dnf module disable nginx -y
dnf module enable nginx:1.24 -y
dnf install nginx -y &>> LOGFILE

systemctl enable nginx 
systemctl start nginx &>> LOGFILE

rm -rf /usr/share/nginx/html/* &>> LOGFILE

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>> LOGFILE

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip

 rm /etc/nginx/nginx.conf &>> LOGFILE

 touch /etc/nginx/nginx.conf &>> LOGFILE

 cp /home/ec2-user/roboshopshell/nginx.conf /etc/nginx/nginx.conf &>> LOGFILE

 systemctl restart nginx &>> LOGFILE



