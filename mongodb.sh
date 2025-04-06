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

cp  path to mongorepo mongo.repo /etc/yum.repos.d/mongo.repo &>> LOGFILE

VALIDATE $? "Copied MongoDB Repo"

dnf install mongodb-org -y  &>> LOGFILE

VALIDATE $? "Installed Mongodb"

systemctl enable mongod  &>> LOGFILE

VALIDATE $? "Enabled mongodb"

systemctl start mongod  &>> LOGFILE

VALIDATE $? "started mongodb"

cp /etc/mongod.conf /etc/mongod.conf.bak  &>> LOGFILE

VALIDATE $? "Copied backup"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf  &>> LOGFILE

VALIDATE $? "changed listener adress"

systemctl restart mongod  &>> LOGFILE

VALIDATE $? "Restarted mongodb"







