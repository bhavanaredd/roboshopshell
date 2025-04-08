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

dnf install maven -y  &>> LOGFILE

useradd roboshop  &>> LOGFILE

mkdir /app  &>> LOGFILE

curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip  &>> LOGFILE

cd /app 

unzip /tmp/shipping.zip  &>> LOGFILE

cd /app 

mvn clean package  &>> LOGFILE

mv target/shipping-1.0.jar shipping.jar  &>> LOGFILE

cp path to shipping.service /etc/systemd/system/shipping.service  &>> LOGFILE

Validate $? "copied shipping service file"

systemctl daemon-reload

Validate $? "reload"

systemctl enable shipping 

Validate $? "enable shipping"

systemctl start shipping  &>> LOGFILE

Validate $? "start shipping"

dnf install mysql -y  &>> LOGFILE

Validate $? "Install mysql"

mysql -h mysql.bhavana.store -uroot -pRoboShop@1 < /app/db/schema.sql  &>> LOGFILE

mysql -h mysql.bhavana.store -uroot -pRoboShop@1 < /app/db/app-user.sql  &>> LOGFILE

mysql -h mysql.bhavana.store -uroot -pRoboShop@1 < /app/db/master-data.sql  &>> LOGFILE

systemctl restart shipping  &>> LOGFILE

Validate $? "restart shipping"



