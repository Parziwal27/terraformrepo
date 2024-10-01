# modules/rds/main.tf

resource "aws_db_instance" "this" {
  allocated_storage    = 20  # Free Tier limit
  storage_type         = "gp2"  # General-purpose SSD
  engine               = var.engine  # "mysql" or "postgres"
  engine_version       = var.engine_version
  instance_class       = var.instance_class  # Free Tier eligible t2.micro
  db_name              = var.db_name
  username             = var.username
  password             = var.password
  db_subnet_group_name = aws_db_subnet_group.this.name
  skip_final_snapshot  = true  # Avoid snapshot costs
  publicly_accessible  = false  # Keep DB private for security reasons
  vpc_security_group_ids = [var.security_group_id]

  tags = merge({
    Name = var.db_name
  }, var.tags)
}

# RDS Subnet Group
resource "aws_db_subnet_group" "this" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge({
    Name = "${var.db_name}-subnet-group"
  }, var.tags)
}
