output "iam_role_arn" {
  description = "ARN of the IAM role created for EKS Pod Identity"
  value       = module.eks_pod_identity.iam_role_arn
}

output "iam_role_name" {
  description = "Name of the IAM role created for EKS Pod Identity"
  value       = module.eks_pod_identity.iam_role_name
}

output "iam_role_path" {
  description = "Path of the IAM role created for EKS Pod Identity"
  value       = module.eks_pod_identity.iam_role_path
}

output "iam_role_unique_id" {
  description = "Unique ID of the IAM role created for EKS Pod Identity"
  value       = module.eks_pod_identity.iam_role_unique_id
}

output "iam_policy_arn" {
  description = "ARN of the first IAM policy created by the module, or null when no policy is created"
  value       = module.eks_pod_identity.iam_policy_arn
}

output "iam_policy_name" {
  description = "Name of the first IAM policy created by the module, or null when no policy is created"
  value       = module.eks_pod_identity.iam_policy_name
}

output "iam_policy_id" {
  description = "ID of the first IAM policy created by the module, or null when no policy is created"
  value       = module.eks_pod_identity.iam_policy_id
}
