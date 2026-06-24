output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = module.ec2_instance.id
}

output "instance_state" {
  description = "The current state of the EC2 instance"
  value       = module.ec2_instance.instance_state
}

output "instance_ami_id" {
  description = "The AMI ID used to create the EC2 instance"
  value       = module.ec2_instance.ami
}

output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = module.ec2_instance.public_ip
}

output "instance_public_dns" {
  description = "The public DNS name of the EC2 instance"
  value       = module.ec2_instance.public_dns
}

output "instance_private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = module.ec2_instance.private_ip
}

output "instance_private_dns" {
  description = "The private DNS name of the EC2 instance"
  value       = module.ec2_instance.private_dns
}

output "instance_ipv6_addresses" {
  description = "IPv6 addresses assigned to the EC2 instance"
  value       = module.ec2_instance.ipv6_addresses
}

output "instance_arn" {
  description = "The ARN of the EC2 instance"
  value       = module.ec2_instance.arn
}

output "instance_primary_network_interface_id" {
  description = "The ID of the EC2 instance primary network interface"
  value       = module.ec2_instance.primary_network_interface_id
}

output "instance_iam_instance_profile_arn" {
  description = "The ARN of the IAM instance profile created by this module, or null when one is not created"
  value       = module.ec2_instance.iam_instance_profile_arn
}

output "instance_iam_instance_profile_id" {
  description = "The ID of the IAM instance profile created by this module, or null when one is not created"
  value       = module.ec2_instance.iam_instance_profile_id
}

output "instance_security_group_id" {
  description = "The ID of the security group created by this module, or null when one is not created"
  value       = module.ec2_instance.security_group_id
}

output "instance_security_group_arn" {
  description = "The ARN of the security group created by this module, or null when one is not created"
  value       = module.ec2_instance.security_group_arn
}

output "instance_subnet_id" {
  description = "The configured subnet ID for the EC2 instance"
  value       = var.subnet_id
}

output "instance_vpc_id" {
  description = "The configured VPC ID for the module-created security group; may be null when no security group is created"
  value       = var.security_group_vpc_id
}

output "instance_availability_zone" {
  description = "The availability zone the EC2 instance is launched in"
  value       = module.ec2_instance.availability_zone
}

output "instance_iam_role_name" {
  description = "The name of the IAM role created by this module, or null when one is not created"
  value       = module.ec2_instance.iam_role_name
}

output "instance_iam_role_arn" {
  description = "The ARN of the IAM role created by this module, or null when one is not created"
  value       = module.ec2_instance.iam_role_arn
}

output "ebs_volumes" {
  description = "Map of additional EBS volumes created by this module"
  value       = module.ec2_instance.ebs_volumes
}
