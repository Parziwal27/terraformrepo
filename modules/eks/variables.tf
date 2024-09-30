# modules/eks/variables.tf

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Version of Kubernetes"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for worker nodes"
  type        = list(string)
}

variable "control_plane_subnet_ids" {
  description = "List of subnet IDs for control plane"
  type        = list(string)
}

variable "node_group_instance_types" {
  description = "Instance types for node group"
  type        = list(string)
}

variable "node_group_ami_type" {
  description = "AMI type for node group"
  type        = string
}

variable "node_group_desired_size" {
  description = "Desired size of the node group"
  type        = number
  default     = 1
}

variable "node_group_min_size" {
  description = "Minimum size of the node group"
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "Maximum size of the node group"
  type        = number
  default     = 1
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
