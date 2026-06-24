output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = module.eks.cluster_arn
}

output "cluster_endpoint" {
  description = "Endpoint of the Kubernetes API server"
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded certificate authority data for the cluster"
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_version" {
  description = "Kubernetes version of the EKS cluster"
  value       = module.eks.cluster_version
}

output "cluster_platform_version" {
  description = "AWS EKS platform version of the cluster"
  value       = module.eks.cluster_platform_version
}

output "cluster_status" {
  description = "Status of the EKS cluster"
  value       = module.eks.cluster_status
}

output "cluster_service_cidr" {
  description = "CIDR block used for Kubernetes service IP addresses"
  value       = module.eks.cluster_service_cidr
}

output "cluster_ip_family" {
  description = "IP family used by the EKS cluster"
  value       = module.eks.cluster_ip_family
}

output "cluster_primary_security_group_id" {
  description = "Primary security group created by Amazon EKS"
  value       = module.eks.cluster_primary_security_group_id
}

output "cluster_security_group_arn" {
  description = "ARN of the cluster security group created by the EKS module"
  value       = module.eks.cluster_security_group_arn
}

output "cluster_security_group_id" {
  description = "ID of the cluster security group created by the EKS module"
  value       = module.eks.cluster_security_group_id
}

output "node_security_group_arn" {
  description = "ARN of the shared node security group"
  value       = module.eks.node_security_group_arn
}

output "node_security_group_id" {
  description = "ID of the shared node security group"
  value       = module.eks.node_security_group_id
}

output "cluster_iam_role_name" {
  description = "Name of the EKS cluster IAM role"
  value       = module.eks.cluster_iam_role_name
}

output "cluster_iam_role_arn" {
  description = "ARN of the EKS cluster IAM role"
  value       = module.eks.cluster_iam_role_arn
}

output "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL of the EKS cluster"
  value       = module.eks.cluster_oidc_issuer_url
}

output "oidc_provider_arn" {
  description = "ARN of the IAM OIDC provider, or null when IRSA is disabled"
  value       = module.eks.oidc_provider_arn
}

output "access_entries" {
  description = "EKS access entries created for the cluster"
  value       = module.eks.access_entries
}

output "access_policy_associations" {
  description = "EKS access policy associations created for the cluster"
  value       = module.eks.access_policy_associations
}

output "cluster_addons" {
  description = "EKS add-ons created for the cluster"
  value       = module.eks.cluster_addons
}

output "eks_managed_node_groups" {
  description = "EKS managed node groups and their attributes"
  value       = module.eks.eks_managed_node_groups
}

output "eks_managed_node_groups_autoscaling_group_names" {
  description = "Autoscaling group names created for the managed node groups"
  value       = module.eks.eks_managed_node_groups_autoscaling_group_names
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group created for EKS control-plane logs"
  value       = module.eks.cloudwatch_log_group_name
}

output "cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch log group created for EKS control-plane logs"
  value       = module.eks.cloudwatch_log_group_arn
}

output "kubectl_config_command" {
  description = "AWS CLI command to configure kubectl using the AWS CLI current or default region"
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name}"
}
