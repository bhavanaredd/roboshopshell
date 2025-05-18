#!/bin/bash

# Variables
SECURITY_GROUP_NAME="allow_all_security_group"
SECURITY_GROUP_DESC="Security group that allows all traffic"
REGION="us-east-1" #place your desired region
SIZE1="t2.micro"
SIZE2="t3.small"



# Step 1: Create the Security Group
SECURITY_GROUP_ID=$(aws ec2 create-security-group --group-name $SECURITY_GROUP_NAME --description "$SECURITY_GROUP_DESC" --region $REGION --query 'GroupId' --output text)

# Step 2: Add Inbound (Ingress) Rule to Allow All Traffic
aws ec2 authorize-security-group-ingress --region $REGION --group-id $SECURITY_GROUP_ID --protocol "-1" --port 0 --cidr 0.0.0.0/0

# Step 3: Add Outbound (Egress) Rule to Allow All Traffic
#aws ec2 authorize-security-group-egress --region $REGION --group-id $SECURITY_GROUP_ID --protocol "-1" --port 0 --cidr 0.0.0.0/0

# Output the security group ID
echo "Security group '$SECURITY_GROUP_NAME' created with ID: $SECURITY_GROUP_ID"

Instances=("mongodb" "catalogue" "web")

for instance in "${Instances[@]}"
do
  if [[ "$instance" == "mongodb"]]; then
    instancetype=$SIZE2
  else
    instancetype=$SIZE1
  fi

  aws ec2 run-instances --image-id ami-09c813fb71547fc4f --instance-type $instancetype --security-group-ids $SECURITY_GROUP_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" --region $REGION
  instance_id=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$instance" --query "Reservations[].Instances[].InstanceId" --output text)
  private_ip=$(aws ec2 describe-instances --instance-ids $instance_id --query "Reservations[].Instances[].PrivateIpAddress" --output text)
  public_ip=$(aws ec2 describe-instances --instance-ids $instance_id --query "Reservations[].Instances[].PublicIpAddress" --output text)
  echo "Instance Name: $instance_name"
  echo "Private IP: $private_ip"
  echo "PublicIP: $public_ip"
done


