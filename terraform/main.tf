module "ec2_ami_lookup" {
  source          = "./modules/ec2_ami_lookup"
  ami_owners      = var.ami_owners
  ami_name_filter = var.ami_name_filter
}

data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = var.ami_owners
  filter {
    name   = "name"
    values = [var.ami_name_filter]
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name                 = "wordpress-vpc"
  cidr                 = var.vpc_cidr_block
  azs                  = ["us-east-2a", "us-east-2b"]
  public_subnets       = ["10.0.101.0/24", "10.0.102.0/24"]
  enable_dns_hostnames = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "tls_private_key" "ec2_key_pair" {
  algorithm = "RSA"
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "wordpress-key"
  public_key = tls_private_key.ec2_key_pair.public_key_openssh
}

module "wordpress_ec2" {
  source   = "terraform-aws-modules/ec2-instance/aws"
  version  = "5.2.1"
  for_each = {
    "wordpress-instance-1" = {}
    "wordpress-instance-2" = {}
  }

  name                          = each.key
  ami                           = module.ec2_ami_lookup.ami_id
  instance_type                 = "t2.micro"
  subnet_id                     = module.vpc.public_subnets[0]
  associate_public_ip_address   = true
  key_name                      = aws_key_pair.ec2_key_pair.key_name
  vpc_security_group_ids        = [module.vpc.default_security_group_id]

  tags = {
    Name = each.key
  }

}

module "database_ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.2.1"

  for_each = {
    "database-instance" = {}
  }

  name                          = each.key
  ami                           = module.ec2_ami_lookup.ami_id
  instance_type                 = "t2.micro"
  subnet_id                     = module.vpc.public_subnets[0]
  associate_public_ip_address   = true
  key_name                      = aws_key_pair.ec2_key_pair.key_name
  vpc_security_group_ids        = [module.vpc.default_security_group_id]

  tags = {
    Name = each.key
  }
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "8.7.0"

  name            = "wordpress-alb"
  subnets         = module.vpc.public_subnets
  security_groups = [module.vpc.default_security_group_id]
  vpc_id          = module.vpc.vpc_id

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


resource "aws_lb_target_group" "wordpress_target_group" {
  name     = "wordpress-target-group"
  port     = var.http_port
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path     = "/"
    port     = "traffic-port"
    protocol = "HTTP"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = module.alb.lb_arn
  port              = var.http_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.wordpress_target_group.arn
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "wordpress_host_header_rule" {
  listener_arn = aws_lb_listener.alb_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_target_group.arn
  }

  condition {
    host_header {
      values = ["wordpress.dext.local"]
    }
  }
}

resource "aws_lb_listener_rule" "wordpress_path_rule" {
  listener_arn = aws_lb_listener.alb_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/wordpress/*"]
    }
  }
}

# ALB Target Group Attachment
# Create ALB target group attachments
resource "aws_lb_target_group_attachment" "wordpress_attachment_instance_1" {
  target_group_arn = aws_lb_target_group.wordpress_target_group.arn
  target_id       = module.wordpress_ec2["wordpress-instance-1"].id
}

resource "aws_lb_target_group_attachment" "wordpress_attachment_instance_2" {
  target_group_arn = aws_lb_target_group.wordpress_target_group.arn
  target_id       = module.wordpress_ec2["wordpress-instance-2"].id
}


# Security Group Rules

resource "aws_security_group_rule" "alb_http_ingress" {
  type                     = "ingress"
  from_port                = var.http_port
  to_port                  = var.http_port
  protocol                 = "tcp"
  security_group_id        = module.alb.security_group_id
  source_security_group_id = module.vpc.default_security_group_id
}

resource "aws_security_group_rule" "alb_http_egress" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = module.alb.security_group_id
  source_security_group_id = module.vpc.default_security_group_id
}

resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  from_port         = var.http_port
  to_port           = var.http_port
  protocol          = "tcp"
  security_group_id = module.vpc.default_security_group_id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = module.vpc.default_security_group_id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access from anywhere (not recommended for production)
  security_group_id = module.vpc.default_security_group_id
}

resource "aws_security_group_rule" "all_ingress" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = module.vpc.default_security_group_id
  source_security_group_id = module.vpc.default_security_group_id
}

# Store the SSH private key in a file with 600 permissions
resource "local_file" "private_key" {
  filename        = "../ansible/wordpress-key.pem"
  content         = tls_private_key.ec2_key_pair.private_key_pem
  file_permission = "0600"
}
