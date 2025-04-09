#!bin/bash

#!/bin/bash

# Variables
SECURITY_GROUP_NAME="allow_all_security_group"
SECURITY_GROUP_DESC="Security group that allows all traffic"
REGION="us-east-1" #place your desired region
SiZE1=t2.micro
SIZE2=t3.small



# Step 1: Create the Security Group
SECURITY_GROUP_ID=$(aws ec2 create-security-group --group-name $SECURITY_GROUP_NAME --description "$SECURITY_GROUP_DESC" --region $REGION --query 'GroupId' --output text)

# Step 2: Add Inbound (Ingress) Rule to Allow All Traffic
aws ec2 authorize-security-group-ingress --region $REGION --group-id $SECURITY_GROUP_ID --protocol "-1" --port 0 --cidr 0.0.0.0/0

# Step 3: Add Outbound (Egress) Rule to Allow All Traffic
aws ec2 authorize-security-group-egress --region $REGION --group-id $SECURITY_GROUP_ID --protocol "-1" --port 0 --cidr 0.0.0.0/0

# Output the security group ID
echo "Security group '$SECURITY_GROUP_NAME' created with ID: $SECURITY_GROUP_ID"

Instances= ("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "cart" "user" "shipping" "payment" "dispatch" "web")

for Instances in ${array[@]}"
do
  if [[ "$Instances" == "mongodb" || "$Instances" == "shipping" || "$Instances" == "payment"]]; then
  
  instancetype=$SIZE2

  else 

  instancetype=$SIZE1

  aws ec2 run-instances --image-id <ami-id> --instance-type $instancetype --security-group-ids $SECURITY_GROUP_ID  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=$Instances}]' --region $REGION

done




