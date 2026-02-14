variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "my-vpc"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "owner" {
  type    = string
  default = "portfolio"
}

variable "vpc_name" {
  type    = string
  default = "my-vpc"

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.vpc_name)) && length(var.vpc_name) >= 1 && length(var.vpc_name) <= 64
    error_message = "vpc_name must be 1-64 chars and use only letters, numbers, and hyphens."
  }
}

variable "availability_zone" {
  type    = string
  default = "us-east-1a"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"

  validation {
    condition     = contains(["t3.micro", "t3.small", "t3.medium"], var.instance_type)
    error_message = "instance_type must be one of: t3.micro, t3.small, t3.medium."
  }
}

variable "latest_ami_ssm_param" {
  type    = string
  default = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
}
