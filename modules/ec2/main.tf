# modules/ec2/main.tf

resource "aws_instance" "this" {
  ami           = data.aws_ami.ubuntu.id  # Using a Ubuntu AMI
  instance_type = var.instance_type
  subnet_id     = var.public_subnet
  key_name      = var.key_name

  vpc_security_group_ids = [var.security_group_id]  # Use the security group from the new module

  tags = merge({
    Name = var.instance_name
  }, var.tags)
}

# Data block to fetch the latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]  # Canonical's AWS account ID
}
