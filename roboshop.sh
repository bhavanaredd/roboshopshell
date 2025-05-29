#!/bin/bash

# Variables
SECURITY_GROUP_NAME="allow_all_security_group"
SECURITY_GROUP_DESC="Security group that allows all traffic"
REGION="us-east-1"
SIZE1="t2.micro"
SIZE2="t3.small"
AMI_ID="ami-09c813fb71547fc4f" # Replace with valid AMI for your region
# shellcheck disable=SC2034
#KEY_NAME="your-key-pair-name"  # Optional: replace with your EC2 key pair if needed

# Step 1: Create the Security Group
SECURITY_GROUP_ID=$(aws ec2 create-security-group \
  --group-name "$SECURITY_GROUP_NAME" \
  --description "$SECURITY_GROUP_DESC" \
  --region "$REGION" \
  --query 'GroupId' \
  --output text)

# Step 2: Allow all inbound traffic
aws ec2 authorize-security-group-ingress \
  --region "$REGION" \
  --group-id "$SECURITY_GROUP_ID" \
  --protocol "-1" \
  --port -1 \
  --cidr 0.0.0.0/0

echo " Security group '$SECURITY_GROUP_NAME' created with ID: $SECURITY_GROUP_ID"

# Step 3: Launch instances
Instances=("mongodb" "catalogue" "web")

for instance in "${Instances[@]}"; do
  if [[ "$instance" == "mongodb" ]]; then
    instancetype=$SIZE2
  else
    instancetype=$SIZE1
  fi

  echo "🚀 Launching instance: $instance ($instancetype)"

  # Run EC2 instance
  run_output=$(aws ec2 run-instances \
    --image-id "$AMI_ID" \
    --instance-type "$instancetype" \
    --security-group-ids "$SECURITY_GROUP_ID" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
    --region "$REGION" \
    --query 'Instances[0].InstanceId' \
    --output text)

  instance_id="$run_output"

  # Wait for instance to be running (avoid race conditions)
  echo "⏳ Waiting for instance $instance_id to be running..."
  aws ec2 wait instance-running --instance-ids "$instance_id" --region "$REGION"

  # Get IP addresses
  private_ip=$(aws ec2 describe-instances \
    --instance-ids "$instance_id" \
    --query "Reservations[].Instances[].PrivateIpAddress" \
    --region "$REGION" \
    --output text)

  public_ip=$(aws ec2 describe-instances \
    --instance-ids "$instance_id" \
    --query "Reservations[].Instances[].PublicIpAddress" \
    --region "$REGION" \
    --output text)

  echo "Instance Name: $instance"
  echo "   Instance ID: $instance_id"
  echo "   Private IP: $private_ip"
  echo "   Public IP:  $public_ip"
  echo "------------------------------------------"
done
