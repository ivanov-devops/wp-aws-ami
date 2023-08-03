data "aws_ami" "latest_amazon_linux" {
  owners      = var.ami_owners
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name_filter]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


output "ami_id" {
  value = data.aws_ami.latest_amazon_linux.id
}
