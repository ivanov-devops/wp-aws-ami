output "alb_dns_name" {
  value = module.alb.lb_dns_name
}

output "wordpress_instances_public_ips" {
  value = {
    for instance_key, instance_value in module.wordpress_ec2 :
    instance_key => instance_value.public_ip
  }
}

output "database_instance_private_ip" {
  value = module.database_ec2["database-instance"].private_ip
}

output "private_key_pem" {
  sensitive = true
  value = tls_private_key.ec2_key_pair.private_key_pem
}

output "efs_dns_name" {
  value = aws_efs_file_system.efs.dns_name
}
