variable "project" {}

variable "environment" {}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "cidr" {
  description = "The CIDR block for the VPC."
}

variable "public_subnets" {
  description = "List of public subnets"
}

variable "private_subnets" {
  description = "List of private subnets"
}

variable "availability_zones" {
  description = "List of availability zones"
}

variable "container_port" {}
variable "image" {}
variable "task_cpu" {}
variable "task_memory" {}
variable "secrets" {}
variable "domain" {}
