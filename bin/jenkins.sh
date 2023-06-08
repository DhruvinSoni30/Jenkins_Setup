#!/bin/bash
# Installing dependencies
touch /tmp/log.txt
sudo apt-get update 
sudo apt-get install jq -y
sudo apt-get install awscli -y
sudo apt install openjdk-11-jdk -y
wget -p -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y
code=$?
echo $code >> /tmp/log.txt
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo ufw allow 8080
sudo ufw status
sudo ufw enable


# Getting Instance details
identity_doc=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document/)
availability_zone=$(echo "$identity_doc" | jq -r '.availabilityZone')
instance_id=$(echo "$identity_doc" | jq -r '.instanceId')
private_ip=$(echo "$identity_doc" | jq -r '.privateIp')
public_ip=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
account_id=$(echo "$identity_doc" | jq -r '.accountId')
region=$(echo "$identity_doc" | jq -r '.region')

# Variable
ebs_device="/dev/xvdf"

# Retrieving the volume ids whose state is available
volume_ids=$(aws ec2 describe-volumes --region "$region" --filters Name=tag:"Name",Values="Jenkins Volume" Name=availability-zone,Values="$availability_zone" Name=status,Values=available | jq -r '.Volumes[].VolumeId')	

# Attaching the volume to the Instance (The volume will remain the same after instance gets reprovision)
for volume_id in $volume_ids; do
    aws ec2 attach-volume --region "$region" --volume-id "$volume_id" --instance-id "$instance_id" --device "$ebs_device"
done