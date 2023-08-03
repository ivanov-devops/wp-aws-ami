variable "ami_owners" {
  type    = list(string)
  default = ["your_ami_owner_id"]
}

variable "ami_name_filter" {
  type    = string
  default = "amzn2-ami-hvm-*-x86_64-gp2"
}
