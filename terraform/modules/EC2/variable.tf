variable ami {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
  default     = null
}
variable ami_ssm_parameter {
  description = "The SSM parameter name to retrieve the AMI ID from"
  type        = string
  default     = null
}
variable associate_public_ip_address {
  description = "Whether to associate a public IP address with the instance"
  type        = bool
  default     = null
}
variable create_eip {
  description = "Determines whether a public EIP will be created and associated with the instance."
  type        = bool
  default     = false
}
variable create_iam_instance_profile {
  description = "Determines whether an IAM instance profile is created or to use an existing IAM instance profile"
  type        = bool
  default     = false
}
variable create_security_group {
  description = "Determines whether a security group will be created"
  type        = bool
  default     = false
}
variable ebs_optimized {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  type        = bool
  default     = false
}
variable eip_domain {
  description = "The domain of the EIP to allocate. Valid values are vpc and standard."
  type        = string
  default     = "vpc"
}
variable eip_tags {
  description = "A map of tags to assign to the EIP"
  type        = map(string)
  default     = {}
}
variable enable_volume_tags {
  description = "Whether to enable volume tags (if enabled it conflicts with root_block_device tags)"
  type        = bool
  default     = true
}
variable iam_instance_profile {
  description = "IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile"
  type        = string
  default     = null
}
variable iam_role_description {
  description = "Description of the IAM role to create and launch the instance with. See the README for details."
  type        = string
  default     = null
}
variable iam_role_name {
  description = "Name of the IAM role to create and launch the instance with. See the README for details."
  type        = string
  default     = null
}
variable iam_role_permissions_boundary {
  description = "The ARN of the policy used to set the permissions boundary for the IAM role. See the README for details."
  type        = string
  default     = null
}
variable iam_role_path {
  description = "IAM role path"
  type        = string
  default     = null
}
variable iam_role_policies {
  description = "Policies attached to the IAM role"
  type        = map(string)
  default     = {}
}
variable iam_role_tags {
  description = "A map of tags to assign to the IAM role"
  type        = map(string)
  default     = {}
}
variable instance_type {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}
variable instance_tags {
  description = "A map of tags to assign to the instance"
  type        = map(string)
  default     = {}
}
variable key_name {
  description = "The name of the key pair to use for the instance"
  type        = string
  default     = null
}
variable ec2_name {
  description = "The name of the instance"
  type        = string
  default     = null
}
variable security_group_description {
  description = "Description of the security group to create"
  type        = string
  default     = null
}
variable security_group_egress_rules {
  description = "Egress rules to add to the security group"
  type        = map(object({
    cidr_ipv4 = optional(string)
    cidr_ipv6 = optional(string)
    description = optional(string)
    from_port   = optional(number)
    ip_protocol = optional(string)
    prefix_list_ids = optional(string)
    reference_security_group_id = optional(string)
    tags = optional(map(string))
    to_port = optional(number)
  }))
  default     = {"ipv4_default": {
    "cidr_ipv4" = "0.0.0.0/0",
    "description" = "Allow all outbound IPv4 traffic",
    "ip_protocol" = "-1"}
    "ipv6_default": {
    "cidr_ipv6" = "::/0",
    "description" = "Allow all outbound IPv6 traffic",
    "ip_protocol" = "-1"}
}
}
variable security_group_ingress_rules {
  description = "Ingress rules to add to the security group"
  type        = map(object({
    cidr_ipv4 = optional(string)
    cidr_ipv6 = optional(string)
    description = optional(string)
    from_port   = optional(number)
    ip_protocol = optional(string)
    prefix_list_ids = optional(string)
    reference_security_group_id = optional(string)
    tags = optional(map(string))
    to_port = optional(number)
  }))
  default     = null
}
variable security_group_tags {
  description = "A map of tags to assign to the security group"
  type        = map(string)
  default     = {}
}
variable security_group_name {
  description = "Name of the security group to create"
  type        = string
  default     = null
}
variable security_group_vpc_id {
  description = "VPC ID to create the security group in"
  type        = string
  default     = null
}
variable subnet_id {
  description = "The VPC Subnet ID to launch the instance in"
  type        = string
  default     = null
}
variable tags {
  description = "A map of tags to assign to all resources"
  type        = map(string)
  default     = {}
}
variable user_data {
  description = "The user data to provide when launching the instance. Do not pass base64-encoded data via this argument. It will be auto-encoded by Terraform."
  type        = string
  default     = null
}
variable vpc_security_group_ids {
  description = "A list of VPC security group IDs to associate with the instance. This is required if create_security_group is false and security_group_ids is not provided."
  type        = list(string)
  default     = []
}
variable root_block_device {
  description = "Configuration block for the root block device of the instance. See the README for details."
  type        = object({
    delete_on_termination = optional(bool)
    encrypted = optional(bool)
    iops = optional(number)
    kms_key_id = optional(string)
    tags = optional(map(string))
    throughput = optional(number)
    volume_size = optional(number)
    volume_type = optional(string)
  })
  default     = null
}
variable ebs_volumes {
  description = "Additional EBS volumes to attach to the instance"
  type        = map(object({
    encrypted = optional(bool)
    final_snapshot = optional(bool)
    iops = optional(number)
    kms_key_id = optional(string)
    multi_attach_enabled = optional(bool)
    outpost_arn = optional(string)
    size = optional(number)
    snapshot_id = optional(string)
    tags = optional(map(string), {})
    throughput = optional(number)
    type = optional(string, "gp3")
    volume_initialization_rate = optional(number)
    device_name = optional(string)
    force_detach = optional(bool)
    skip_destroy = optional(bool)
    stop_instance_before_detaching = optional(bool)
  }))
  default = null
}