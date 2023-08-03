resource "aws_efs_file_system" "efs" {
  creation_token = "wordpress-efs"
  tags = {
    Name = "wordpress-efs"
  }

  lifecycle {
    ignore_changes = [
      creation_token,
      tags,
      encrypted,
    ]
  }

  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
}

resource "aws_efs_access_point" "efs_access_point" {
  file_system_id = aws_efs_file_system.efs.id
  tags = {
    Name = "wordpress-efs-access-point"
  }

  posix_user {
    uid = "1000"
    gid = "1000"
  }

  root_directory {
    path = "/var/www/html"
    creation_info {
      owner_uid    = "1000"
      owner_gid    = "1000"
      permissions = "777"
    }
  }
}

resource "aws_efs_mount_target" "efs_mount_target" {
  count = length(module.vpc.public_subnets)

  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = module.vpc.public_subnets[count.index]
  security_groups = [module.vpc.default_security_group_id]
}
