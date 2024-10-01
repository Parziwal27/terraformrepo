# main.tf

# Specify the AWS provider and region
provider "aws" {
  region = "ap-south-1" # Change to your preferred region
}

# Call the VPC module
module "vpc" {
  source = "./modules/vpc"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = false # Disable NAT Gateway to avoid costs

  tags = {
    Name = "my-vpc"
  }
}

# Call the Security Group module for EC2
module "ec2_security_group" {
  source = "./modules/security_group"

  vpc_id               = module.vpc.vpc_id
  security_group_name  = "ec2-instance-sg"
  ingress_from_port    = 22
  ingress_to_port      = 22
  ingress_protocol     = "tcp"
  ingress_cidr_blocks  = ["0.0.0.0/0"]

  tags = {
    Name = "ec2-instance-sg"
  }

  depends_on = [module.vpc]  # Ensure VPC is created first
}

# Call the EC2 module
module "ec2" {
  source = "./modules/ec2"

  vpc_id          = module.vpc.vpc_id
  public_subnet   = element(module.vpc.public_subnets, 0)  # First public subnet
  instance_type   = "t2.micro"  # Free Tier eligible
  key_name        = "Terraformjob"  # Replace with your existing key pair
  security_group_id = module.ec2_security_group.security_group_id  # Use the security group from the security_group module
  instance_name   = "my-free-tier-instance"

  tags = {
    Name = "my-ec2-instance"
  }

  depends_on = [module.ec2_security_group]  # Ensure EC2 security group is created first
}

# Call the Security Group module for RDS
module "rds_security_group" {
  source = "./modules/security_group"

  vpc_id               = module.vpc.vpc_id
  security_group_name  = "rds-sg"
  ingress_from_port    = 3306  # MySQL default port (adjust to match your DB engine)
  ingress_to_port      = 3306
  ingress_protocol     = "tcp"
  ingress_cidr_blocks  = ["10.0.0.0/16"]  # Allow access within the VPC

  tags = {
    Name = "rds-sg"
  }

  depends_on = [module.vpc]  # Ensure VPC is created first
}

# Call the RDS module
module "rds" {
  source = "./modules/rds"

  db_name          = "mydatabase"
  username         = "admin"
  password         = "SuperSecurePassword"  # Ideally store this in a secure manner
  engine           = "mysql"
  engine_version   = "8.0.39"
  instance_class   = "db.t3.micro"
  subnet_ids       = module.vpc.private_subnets
  security_group_id = module.rds_security_group.security_group_id

  tags = {
    Name = "my-rds-instance"
  }

  depends_on = [module.rds_security_group]  # Ensure RDS security group is created first
}

# Call the EKS module
module "eks" {
  source = "./modules/eks"

  cluster_name    = "my-cluster"
  cluster_version = "1.30"

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.public_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  node_group_instance_types = ["t3.medium"] # Free Tier eligible instance type
  node_group_ami_type       = "AL2023_x86_64_STANDARD"

  node_group_desired_size = 1
  node_group_min_size     = 1
  node_group_max_size     = 2

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }

  depends_on = [module.vpc]  # Ensure VPC is created first
}
