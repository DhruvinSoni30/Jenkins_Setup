# Stack Name
variable "project_name" {}

# Jenkisns instance type
variable "jenkins_instance_type" {}

# Region
variable "region" {}

# SSH Access
variable "ssh_access" {
  type = list(string)
}

# SSH Access
variable "ui_access" {
  type = list(string)
}

# HTTP Access
variable "http_access" {
  type = list(string)
}

# Desire capacity for Jenkins Node
variable "jenkins_desired_capacity" {
  type    = number
  default = 3
}

# Jenkins volume size
variable "jenkins_volume_size" {
  default = 10
}

# Environment
variable "env" {
  type    = string
  default = "Prod"
}

# Type
variable "type" {
  type    = string
  default = "Production"
}

# Key 
variable "key_name" {
  default = "Demo-key"
}
