# create VPC
module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  env          = var.env
  type         = var.type
}

# create security group
module "security_groups" {
  source       = "./modules/security-group"
  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
  ssh_access   = var.ssh_access
  ui_access    = var.ui_access
  http_access  = var.http_access
  env          = var.env
  type         = var.type
}

# create ALB
module "alb" {
  source               = "./modules/alb"
  project_name         = var.project_name
  alb_security_group   = module.security_groups.alb_security_group_id
  public_subnet_az1_id = module.vpc.public_subnet_az1_id
  public_subnet_az2_id = module.vpc.public_subnet_az2_id
  public_subnet_az3_id = module.vpc.public_subnet_az3_id
  vpc_id               = module.vpc.vpc_id
  env                  = var.env
  type                 = var.type
}

# create asg
module "asg" {
  source                   = "./modules/auto-scalling"
  jenkins_instance_type    = var.jenkins_instance_type
  public_subnet_az1_id     = module.vpc.public_subnet_az1_id
  public_subnet_az2_id     = module.vpc.public_subnet_az2_id
  public_subnet_az3_id     = module.vpc.public_subnet_az3_id
  alb_security_group       = module.security_groups.alb_security_group_id
  project_name             = var.project_name
  target_group_arn         = module.alb.target_group_arn
  jenkins_desired_capacity = var.jenkins_desired_capacity
  jenkins_volume_size      = var.jenkins_volume_size
  env                      = var.env
  type                     = var.type
  key_name                 = var.key_name
  instance_profile        = module.iam.instance_profile
}

# create key pair
module "key_pair" {
  source   = "./modules/key-pair"
  key_name = var.key_name
}

# create IAM resources
module "iam" {
  source = "./modules/iam"
}