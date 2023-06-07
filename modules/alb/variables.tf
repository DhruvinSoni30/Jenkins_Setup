# Environment
variable "env" {
  type = string
}

# Type
variable "type" {
  type = string
}

# Customer name
variable "project_name" {
  type = string
}

# Security group for alb
variable "alb_security_group" {
  type = string
}

# ID of public subnet in az1 
variable "public_subnet_az1_id" {
  type = string
}

# ID of public subnet in az2
variable "public_subnet_az2_id" {
  type = string
}

# ID of pblic subnet in az3
variable "public_subnet_az3_id" {
  type = string
}

# VPC ID
variable "vpc_id" {
  type = string
}

# Healthcheck
variable "health_check" {
  type = map(string)
  default = {
    "timeout"             = "10"
    "interval"            = "20"
    "path"                = "/"
    "port"                = "80"
    "unhealthy_threshold" = "2"
    "healthy_threshold"   = "3"
  }
}