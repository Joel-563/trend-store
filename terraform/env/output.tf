output "vpc_name" {
  description = "The name of the VPC"
  value       = module.vpc.name
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = module.vpc.vpc_arn
}

output "vpc_cidr_block" {
  description = "The primary IPv4 CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}

output "availability_zones" {
  description = "The availability zones used by the VPC subnets"
  value       = module.vpc.availability_zones
}

output "nat_gateway_ids" {
  description = "The IDs of the NAT Gateways"
  value       = module.vpc.nat_gateway_ids
}

output "nat_gateway_public_ips" {
  description = "The public Elastic IP addresses assigned to the NAT Gateways"
  value       = module.vpc.nat_gateway_public_ips
}

output "igw_id" {
  description = "The ID of the Internet Gateway (if created)"
  value       = module.vpc.igw_id
}

output "public_route_table_ids" {
  description = "The IDs of the public route tables"
  value       = module.vpc.public_route_table_ids
}

output "private_route_table_ids" {
  description = "The IDs of the private route tables"
  value       = module.vpc.private_route_table_ids
}

output "route_table_ids" {
  description = "The IDs of all public and private route tables"
  value       = module.vpc.route_table_ids
}

output "key_pair_name" {
  description = "The name of the generated EC2 key pair"
  value       = module.keypair.key_pair_name
}

output "private_key_path" {
  description = "The local path of the generated private key PEM file"
  value       = module.keypair.private_key_path
}

output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = module.ec2_instance.instance_id
}

output "ec2_instance_arn" {
  description = "The ARN of the EC2 instance"
  value       = module.ec2_instance.instance_arn
}

output "ec2_instance_state" {
  description = "The current state of the EC2 instance"
  value       = module.ec2_instance.instance_state
}

output "ec2_instance_ami_id" {
  description = "The AMI ID used by the EC2 instance"
  value       = module.ec2_instance.instance_ami_id
}

output "ec2_public_ip" {
  description = "The public IP address of the EC2 instance, if assigned"
  value       = module.ec2_instance.instance_public_ip
}

output "ec2_public_dns" {
  description = "The public DNS name of the EC2 instance, if assigned"
  value       = module.ec2_instance.instance_public_dns
}

output "ec2_private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = module.ec2_instance.instance_private_ip
}

output "ec2_private_dns" {
  description = "The private DNS name of the EC2 instance"
  value       = module.ec2_instance.instance_private_dns
}

output "ec2_availability_zone" {
  description = "The availability zone of the EC2 instance"
  value       = module.ec2_instance.instance_availability_zone
}

output "ec2_subnet_id" {
  description = "The subnet ID configured for the EC2 instance"
  value       = module.ec2_instance.instance_subnet_id
}

output "security_group_id" {
  description = "The ID of the security group created for the EC2 instance"
  value       = module.ec2_instance.instance_security_group_id
}

output "iam_role_arn" {
  description = "The ARN of the IAM role created for the EC2 instance"
  value       = module.ec2_instance.instance_iam_role_arn
}

output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "eks_cluster_arn" {
  description = "The ARN of the EKS cluster"
  value       = module.eks.cluster_arn
}

output "eks_cluster_endpoint" {
  description = "The endpoint of the Kubernetes API server"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_certificate_authority_data" {
  description = "Base64-encoded certificate authority data for the EKS cluster"
  value       = module.eks.cluster_certificate_authority_data
}

output "eks_cluster_version" {
  description = "The Kubernetes version of the EKS cluster"
  value       = module.eks.cluster_version
}

output "eks_cluster_status" {
  description = "The status of the EKS cluster"
  value       = module.eks.cluster_status
}

output "eks_cluster_service_cidr" {
  description = "The CIDR block used for Kubernetes service IP addresses"
  value       = module.eks.cluster_service_cidr
}

output "eks_cluster_primary_security_group_id" {
  description = "The primary security group created by Amazon EKS"
  value       = module.eks.cluster_primary_security_group_id
}

output "eks_cluster_security_group_id" {
  description = "The ID of the cluster security group created by the EKS module"
  value       = module.eks.cluster_security_group_id
}

output "eks_node_security_group_id" {
  description = "The ID of the shared EKS node security group"
  value       = module.eks.node_security_group_id
}

output "eks_cluster_iam_role_arn" {
  description = "The ARN of the EKS cluster IAM role"
  value       = module.eks.cluster_iam_role_arn
}

output "eks_oidc_provider_arn" {
  description = "The ARN of the EKS IAM OIDC provider, or null when IRSA is disabled"
  value       = module.eks.oidc_provider_arn
}

output "eks_managed_node_groups" {
  description = "The EKS managed node groups and their attributes"
  value       = module.eks.eks_managed_node_groups
}

output "eks_managed_node_groups_autoscaling_group_names" {
  description = "The Auto Scaling group names created for the EKS managed node groups"
  value       = module.eks.eks_managed_node_groups_autoscaling_group_names
}

output "eks_kubectl_config_command" {
  description = "AWS CLI command to configure kubectl for the EKS cluster"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}

output "ebs_csi_pod_identity_role_arn" {
  description = "The ARN of the IAM role used by the EBS CSI driver Pod Identity association"
  value       = module.ebs-pod-identity.iam_role_arn
}

output "ebs_csi_pod_identity_policy_arn" {
  description = "The ARN of the IAM policy created for the EBS CSI driver"
  value       = module.ebs-pod-identity.iam_policy_arn
}

output "vpc_cni_pod_identity_role_arn" {
  description = "The ARN of the IAM role used by the VPC CNI Pod Identity association"
  value       = module.vpc-cni-pod-identity.iam_role_arn
}

output "vpc_cni_pod_identity_policy_arn" {
  description = "The ARN of the IAM policy created for the VPC CNI"
  value       = module.vpc-cni-pod-identity.iam_policy_arn
}
