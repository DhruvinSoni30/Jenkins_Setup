# Environment
variable "env" {
  type = string
}

# Type
variable "type" {
  type = string
}

# Key 
variable "key_name" {}

# Instance type for Jenkins Nodes
variable "jenkins_instance_type" {
  type = string
}

# ID of public subnet in AZ1
variable "public_subnet_az1_id" {
  type = string
}

# ID of public subnet in AZ2
variable "public_subnet_az2_id" {
  type = string
}

# ID of public subnet in AZ3
variable "public_subnet_az3_id" {
  type = string
}

# Desire capacity for Jenkins Nodes
variable "jenkins_desired_capacity" {
  type = number
}

# Indexers security group
variable "alb_security_group" {}

# Stack name
variable "project_name" {}

# Target Group ARN
variable "target_group_arn" {}

# Jenkins Node Volume Size
variable "jenkins_volume_size" {}

# IAM Instance Profile
variable "instance_profile" {}