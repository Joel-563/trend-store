variable additional_policy_arns{
  type = map(string)
  description = "ARNs of additional policies to attach to the IAM role"
  default = {}
}
variable attach_aws_ebs_csi_policy{
  description = "Determines whether to attach the EBS CSI IAM policy to the role"
  type = bool
  default = false
}
variable aws_ebs_csi_policy_name{
  description = "Custom name of the EBS CSI IAM policy"
  default = null
  type = string
}
variable attach_aws_vpc_cni_policy{
  description = "Determines whether to attach the VPC CNI IAM policy to the role"
  type = bool
  default = false
}
variable aws_vpc_cni_policy_name{
  description = "Custom name of the VPC CNI IAM policy"
  type = string
  default = null
}
variable "aws_vpc_cni_enable_ipv4" {
  description = "Determines whether to enable IPv4 permissions for the VPC CNI policy"
  type        = bool
  default     = false
}
variable description{
  type = string
  default = null
}
variable name{
description = "Name of IAM role"
default = ""
type = string
}
