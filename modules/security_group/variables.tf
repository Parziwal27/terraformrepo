# modules/security_group/variables.tf

variable "vpc_id" {
  description = "VPC ID to attach the security group to"
  type        = string
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
}

variable "ingress_from_port" {
  description = "Ingress starting port"
  type        = number
  default     = 22
}

variable "ingress_to_port" {
  description = "Ingress ending port"
  type        = number
  default     = 22
}

variable "ingress_protocol" {
  description = "Ingress protocol"
  type        = string
  default     = "tcp"
}

variable "ingress_cidr_blocks" {
  description = "CIDR blocks for ingress traffic"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Tags to apply to the security group"
  type        = map(string)
  default     = {}
}
