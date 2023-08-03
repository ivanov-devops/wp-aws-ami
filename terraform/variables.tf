# wordpress-infrastructure/terraform/variables.tf

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidr_block" {
  description = "The CIDR block for the private subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
    type     = string
    default  = "t2.micro"
}

variable "alb_listener_port" {
  description = "The port on which the ALB should listen for incoming traffic."
  type        = number
  default     = 80
}

variable "alb_target_port" {
  description = "The port to which the ALB should forward incoming traffic."
  type        = number
  default     = 80
}

variable "alb_target_group_health_check_path" {
  description = "The path for the ALB target group health check."
  type        = string
  default     = "/"
}

variable "ami_owners" {
  default = ["amazon"]
}

variable "ami_name_filter" {
  default = "amzn2-ami-hvm-*-x86_64-gp2"
}

variable "host_header" {
  default = "wordpress.dext.local"
}
