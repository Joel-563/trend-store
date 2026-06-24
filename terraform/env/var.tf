variable "name" {
  description = "The name of the environment"
  type        = string
}
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}
variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.1.0.0/16"
}
variable "azs" {
  description = "A list of availability zones to use for the subnets"
  type        = list(string)
}
variable "create_igw" {
  description = "Whether to create an Internet Gateway for the VPC"
  type        = bool
  default     = false
}
variable "public_subnets" {
  description = "A list of CIDR blocks for the public subnets"
  type        = list(string)
  default     = []
}
variable "private_subnets" {
  description = "A list of CIDR blocks for the private subnets"
  type        = list(string)
  default     = []
}
variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default     = {}
}
variable "ami" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
  default     = null
}
variable "ami_ssm_parameter" {
  description = "The SSM parameter name to retrieve the AMI ID from"
  type        = string
  default     = null
}
variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the instance"
  type        = bool
  default     = null
}
variable "create_eip" {
  description = "Determines whether a public EIP will be created and associated with the instance."
  type        = bool
  default     = false
}
variable "create_iam_instance_profile" {
  description = "Determines whether an IAM instance profile is created or to use an existing IAM instance profile"
  type        = bool
  default     = false
}
variable "create_security_group" {
  description = "Determines whether a security group will be created"
  type        = bool
  default     = false
}
variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  type        = bool
  default     = false
}
variable "eip_domain" {
  description = "The domain of the EIP to allocate. Valid values are vpc and standard."
  type        = string
  default     = "vpc"
}
variable "eip_tags" {
  description = "A map of tags to assign to the EIP"
  type        = map(string)
  default     = {}
}
variable "enable_volume_tags" {
  description = "Whether to enable volume tags (if enabled it conflicts with root_block_device tags)"
  type        = bool
  default     = true
}
variable "iam_instance_profile" {
  description = "IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile"
  type        = string
  default     = null
}
variable "iam_role_description" {
  description = "Description of the IAM role to create and launch the instance with. See the README for details."
  type        = string
  default     = null
}
variable "iam_role_name" {
  description = "Name of the IAM role to create and launch the instance with. See the README for details."
  type        = string
  default     = null
}
variable "iam_role_permissions_boundary" {
  description = "The ARN of the policy used to set the permissions boundary for the IAM role. See the README for details."
  type        = string
  default     = null
}
variable "iam_role_path" {
  description = "IAM role path"
  type        = string
  default     = null
}
variable "iam_role_policies" {
  description = "Policies attached to the IAM role"
  type        = map(string)
  default     = {}
}
variable "iam_role_tags" {
  description = "A map of tags to assign to the IAM role"
  type        = map(string)
  default     = {}
}
variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}
variable "instance_tags" {
  description = "A map of tags to assign to the instance"
  type        = map(string)
  default     = {}
}
variable "key_name" {
  description = "The name of the key pair to use for the instance"
  type        = string
  default     = null
}
variable "ec2_name" {
  description = "The name of the instance"
  type        = string
  default     = null
}
variable "security_group_description" {
  description = "Description of the security group to create"
  type        = string
  default     = null
}
variable "security_group_egress_rules" {
  description = "Egress rules to add to the security group"
  type = map(object({
    cidr_ipv4                   = optional(string)
    cidr_ipv6                   = optional(string)
    description                 = optional(string)
    from_port                   = optional(number)
    ip_protocol                 = optional(string)
    prefix_list_ids             = optional(string)
    reference_security_group_id = optional(string)
    tags                        = optional(map(string))
    to_port                     = optional(number)
  }))
  default = { "ipv4_default" : {
    "cidr_ipv4"   = "0.0.0.0/0",
    "description" = "Allow all outbound IPv4 traffic",
    "ip_protocol" = "-1" }
    "ipv6_default" : {
      "cidr_ipv6"   = "::/0",
      "description" = "Allow all outbound IPv6 traffic",
    "ip_protocol" = "-1" }
  }
}
variable "security_group_ingress_rules" {
  description = "Ingress rules to add to the security group"
  type = map(object({
    cidr_ipv4                   = optional(string)
    cidr_ipv6                   = optional(string)
    description                 = optional(string)
    from_port                   = optional(number)
    ip_protocol                 = optional(string)
    prefix_list_ids             = optional(string)
    reference_security_group_id = optional(string)
    tags                        = optional(map(string))
    to_port                     = optional(number)
  }))
  default = null
}
variable "security_group_tags" {
  description = "A map of tags to assign to the security group"
  type        = map(string)
  default     = {}
}
variable "security_group_name" {
  description = "Name of the security group to create"
  type        = string
  default     = null
}
variable "security_group_vpc_id" {
  description = "VPC ID to create the security group in"
  type        = string
  default     = null
}
variable "subnet_id" {
  description = "The VPC Subnet ID to launch the instance in"
  type        = string
  default     = null
}

variable "user_data" {
  description = "The user data to provide when launching the instance. Do not pass base64-encoded data via this argument. It will be auto-encoded by Terraform."
  type        = string
  default     = null
}
variable "vpc_security_group_ids" {
  description = "A list of VPC security group IDs to associate with the instance. This is required if create_security_group is false and security_group_ids is not provided."
  type        = list(string)
  default     = []
}
variable "root_block_device" {
  description = "Configuration block for the root block device of the instance. See the README for details."
  type = object({
    delete_on_termination = optional(bool)
    encrypted             = optional(bool)
    iops                  = optional(number)
    kms_key_id            = optional(string)
    tags                  = optional(map(string))
    throughput            = optional(number)
    volume_size           = optional(number)
    volume_type           = optional(string)
  })
  default = null
}
variable "ebs_volumes" {
  description = "Additional EBS volumes to attach to the instance"
  type = map(object({
    encrypted                      = optional(bool)
    final_snapshot                 = optional(bool)
    iops                           = optional(number)
    kms_key_id                     = optional(string)
    multi_attach_enabled           = optional(bool)
    outpost_arn                    = optional(string)
    size                           = optional(number)
    snapshot_id                    = optional(string)
    tags                           = optional(map(string), {})
    throughput                     = optional(number)
    type                           = optional(string, "gp3")
    volume_initialization_rate     = optional(number)
    device_name                    = optional(string)
    force_detach                   = optional(bool)
    skip_destroy                   = optional(bool)
    stop_instance_before_detaching = optional(bool)
  }))
  default = null
}
variable "key_pair_name" {
  description = "The name of the key pair to use for the instance"
  type        = string
}
variable "iam_secrets_name" {
  description = "Name of the Secrets Manager secret for storing IAM credential"
  type        = string
  default     = ""
}
variable "iam_tags" {
  description = "Tags to apply to IAM user and secret"
  type        = map(string)
  default     = {}
}
variable "iam_user_name" {
  description = "The name of the IAM user to create"
  type        = string
  default     = ""
}
variable "rsa_bits" {
  description = "The number of bits in the RSA key"
  type        = number
  default     = 4096
}
variable "secrets_description" {
  description = "The description of the IAM secret"
  type        = string
  default     = ""
}
variable "secretsmanager_name" {
  description = "Name of the Secrets Manager secret for storing the PEM file"
  type        = string
  default     = ""
}

variable "addons" {
  description = "EKS add-ons to enable for the cluster"

  type = map(object({
    name                 = optional(string)
    before_compute       = optional(bool, false)
    most_recent          = optional(bool, true)
    addon_version        = optional(string)
    configuration_values = optional(string)

    namespace_config = optional(object({
      namespace = string
    }))

    pod_identity_association = optional(list(object({
      role_arn        = string
      service_account = string
    })))

    preserve                    = optional(bool, true)
    resolve_conflicts_on_create = optional(string, "NONE")
    resolve_conflicts_on_update = optional(string, "OVERWRITE")
    service_account_role_arn    = optional(string)

    timeouts = optional(object({
      create = optional(string)
      update = optional(string)
      delete = optional(string)
    }), {})

    tags = optional(map(string), {})
  }))

  default = {}
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
