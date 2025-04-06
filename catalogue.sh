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
    echo -e " $2  $R Not installed $N properly"
else 
    echo -e " $2 $G Installed $N properly"
fi

dnf module disable nodejs -y  &>> LOGFILE

Validate $? "Disabled Nodejs"

dnf module enable nodejs:20 -y  &>> LOGFILE

Validate $? "Enabled Nodejs20"

dnf install nodejs -y  &>> LOGFILE

Validate $? "Enabled Nodejs20"

useradd roboshop &>> LOGFILE

Validate $? "Roboshop user added"

mkdir /app 

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 

cd /app 

unzip /tmp/catalogue.zip

npm install &>> LOGFILE

cp  path to catalogue.service /etc/systemd/system/catalogue.service

Validate $? "Catalogue service is added"

systemctl daemon-reload

systemctl enable catalogue 

systemctl start catalogue &>> LOGFILE

Validate $? "Catalogue started"

cp mongodbclient.repo /etc/yum.repos.d/mongo.repo &>> LOGFILE

Validate $? "Copied..."

dnf install mongodb-mongosh -y &>> LOGFILE

Validate $? "Installed mongoorg"

mongosh --host mongodb.bhavana.store </app/db/master-data.js &>> LOGFILE

Validate $? "Loaded schema"















