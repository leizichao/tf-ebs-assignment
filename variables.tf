# Define input variables

variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "ap-southeast-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0be9cb9f67c8dabd6"
}

variable "ebs_size" {
  description = "Size of the EBS volume in GB"
  type        = number
  default     = 1
}