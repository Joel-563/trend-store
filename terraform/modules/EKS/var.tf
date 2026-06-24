variable access_entries{
  type = map(object({kubernetes_groups = optional(list(string))
  principal_arn = string
  type = optional(string, "STANDARD")
  user_name = optional (string)
  tags = optional(map(string),{})
  policy_associations = optional(map(object({policy_arn = string
  access_scope = object({namespaces = optional(list(string))
  type = string }) })),{}) }))
  default = {}
}
variable addons {
  type = map(object({name = optional(string)
  before_compute = optional (bool,false)
  most_recent = optional(bool,true)
  addon_version = optional(string)
  configuration_values = optional(string)
  namespace_config = optional(object({namespace = string}))
  pod_identity_association = optional(list(object({role_arn = string
  service_account = string })))
  preserve = optional(bool,true)
  resolve_conflicts_on_create = optional(string, "NONE")
  resolve_conflicts_on_update = optional (string, "OVERWRITE")
  service_account_role_arn = optional (string)
  timeouts = optional(object({
    create = optional(string)
    update = optional (string)
    delete = optional (string) }), {})
    tags = optional(map(string), {}) }))
  default = {}
}
variable "name" {
  description = "Name of the EKS cluster"
  type        = string
}
variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = null
}
variable "vpc_id" {
  description = "ID of the VPC where the EKS cluster will be created"
  type        = string
}
variable "subnet_ids" {
  description = "Subnet IDs used by the EKS cluster and managed node groups"
  type        = list(string)
}
variable "endpoint_public_access" {
  description = "Whether the EKS public API endpoint is enabled"
  type        = bool
  default     = true
}
variable "endpoint_public_access_cidrs"{
  type = list(string)
  default = ["0.0.0.0/0"]
}
variable "endpoint_private_access" {
  description = "Whether the EKS private API endpoint is enabled"
  type        = bool
  default     = true
}
variable "enable_cluster_creator_admin_permissions" {
  description = "Grant the Terraform caller administrator access to the cluster"
  type        = bool
  default     = true
}
variable "tags" {
  description = "Tags applied to all EKS resources"
  type        = map(string)
  default     = {}
}
variable authentication_mode{
  type = string
  default = "API_AND_CONFIG_MAP"
}
variable cluster_tags{
  type = map(string)
  default = {}
}
variable control_plane_subnet_ids{
  type = list(string)
  description = "A list of subnet IDs where the EKS cluster control plane (ENIs) will be provisioned. Used for expanding the pool of subnets used by nodes/node groups without replacing the EKS control plane"
  default = []
}
variable create_node_iam_role{
  description = "Determines whether an EKS Auto node IAM role is created"
  type = bool
  default = false
}

variable "eks_managed_node_groups" {
  description = "Configuration for EKS managed node groups"

  type = map(object({
    create             = optional(bool, true)
    name               = optional(string)
    kubernetes_version = optional(string)

    subnet_ids     = optional(list(string))
    min_size       = optional(number, 1)
    max_size       = optional(number, 3)
    desired_size   = optional(number, 1)
    instance_types = optional(list(string), ["t3.medium"])
    capacity_type  = optional(string, "ON_DEMAND")

    ami_id                         = optional(string)
    ami_type                       = optional(string)
    ami_release_version            = optional(string)
    use_latest_ami_release_version = optional(bool)
    disk_size                      = optional(number)

    labels = optional(map(string), {})

    taints = optional(map(object({
      key    = string
      value  = optional(string)
      effect = string
    })), {})

    update_config = optional(object({
      max_unavailable            = optional(number)
      max_unavailable_percentage = optional(number)
      update_strategy            = optional(string)
    }))

    remote_access = optional(object({
      ec2_ssh_key               = optional(string)
      source_security_group_ids = optional(list(string), [])
    }))

    create_iam_role              = optional(bool, true)
    iam_role_arn                 = optional(string)
    iam_role_name                = optional(string)
    iam_role_attach_cni_policy   = optional(bool, true)
    iam_role_additional_policies = optional(map(string), {})

    vpc_security_group_ids                = optional(list(string), [])
    attach_cluster_primary_security_group = optional(bool, false)
    create_security_group                 = optional(bool)

    tags = optional(map(string), {})
  }))

  default = {}
}
