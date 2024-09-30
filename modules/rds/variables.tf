# modules/rds/variables.tf

variable "db_name" {
  description = "The name of the RDS database"
  type        = string
}

variable "username" {
  description = "The master username for the RDS instance"
  type        = string
}

variable "password" {
  description = "The master password for the RDS instance"
  type        = string
  sensitive   = true
}

variable "engine" {
  description = "The database engine to use (e.g., MySQL, PostgreSQL)"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "The version of the database engine"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "The instance class to use for the RDS instance"
  type        = string
  default     = "db.t2.micro"  # Free Tier eligible
}

variable "subnet_ids" {
  description = "The subnet IDs for the RDS subnet group"
  type        = list(string)
}

variable "security_group_id" {
  description = "The security group ID for RDS access"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
