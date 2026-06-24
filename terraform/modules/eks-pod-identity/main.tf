module "eks_pod_identity" {
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "~> 2.0"

  name        = var.name
  description = var.description

  additional_policy_arns = var.additional_policy_arns

  attach_aws_ebs_csi_policy = var.attach_aws_ebs_csi_policy
  aws_ebs_csi_policy_name   = var.aws_ebs_csi_policy_name

  attach_aws_vpc_cni_policy = var.attach_aws_vpc_cni_policy
  aws_vpc_cni_policy_name   = var.aws_vpc_cni_policy_name
  aws_vpc_cni_enable_ipv4   = var.aws_vpc_cni_enable_ipv4
}
