# Variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC ID to deploy resources"
  type        = string
  default     = "vpc-04d5b32b51bacef30"
}

variable "subnet_ids" {
  description = "Subnets for ASG and ALB"
  type        = list(string)
  default     = ["subnet-0f0dc8f386f5575ff", "subnet-0139468bf76f6222c"]
}

variable "security_group_ids" {
  description = "Security groups for instances and ALB"
  type        = list(string)
  default     = ["sg-0ee6436bdccc2269a"]
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-0ecb62995f68bb549"
}

variable "instance_type" {
  description = "Instance type for EC2"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair name for EC2"
  type        = string
  default     = "train2"
}

variable "iam_instance_profile" {
  description = "IAM instance profile name"
  type        = string
  default     = "ec2-admin"
}

variable "asg_min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
  default     = 2
}

variable "asg_desired_capacity" {
  description = "Desired number of instances in ASG"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
  default     = 3
}

variable "alarm_threshold" {
  description = "CPU Utilization threshold for alarm"
  type        = number
  default     = 25
}

variable "notification_email" {
  description = "Email address for SNS notification"
  type        = string
  default     = "techapricate@gmail.com"
}
