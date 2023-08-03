#!/bin/bash

# Install nfs-utils package (for Amazon Linux)
sudo yum install -y nfs-utils

# Replace the "fs-12345678" with your EFS file system ID and "us-east-1" with your AWS region
efs_mount_target_dns="${aws_efs_mount_target.efs_mount_target.*.dns_name}"
efs_mount_point="/var/www/html"

# Wait for EFS DNS name to be available
until [ ! -z "${efs_mount_target_dns}" ]; do
  sleep 2
  efs_mount_target_dns="${aws_efs_mount_target.efs_mount_target.*.dns_name}"
done

# Mount EFS
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 "${efs_mount_target_dns}:/ ${efs_mount_point}"
