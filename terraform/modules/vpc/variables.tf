variable "azs" {
  description = "List of availability zones to use for the subnets."
  type        = list(string)
}
variable "cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}
variable "create_igw" {
  description = "Whether to create an Internet Gateway for the VPC."
  type        = bool
  default     = true
}
variable "name" {
  description = "Name to be used on all the resources as identifier."
  type        = string
}
variable "igw_tags" {
  description = "Tags to be applied to the Internet Gateway."
  type        = map(string)
  default     = {}
}
variable "public_subnets" {
  description = "List of CIDR blocks for the public subnets."
  type        = list(string)
}
variable "private_subnets" {
  description = "List of CIDR blocks for the private subnets."
  type        = list(string)
}
variable "enable_dns_support" {
  description = "Whether to enable DNS support in the VPC."
  type        = bool
  default     = true
}
variable "enable_dns_hostnames" {
  description = "Whether to enable DNS hostnames in the VPC."
  type        = bool
  default     = true
}
variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = false
}
variable "one_nat_gateway_per_az" {
  description = "Should be true if you want to provision one NAT Gateway per availability zone (instead of one per private subnet)"
  type        = bool
  default     = false
}
variable "nat_gateway_tags" {
  description = "Tags to be applied to the NAT Gateways."
  type        = map(string)
  default     = {}
}
variable "public_subnet_tags" {
  description = "Tags to be applied to the public subnets."
  type        = map(string)
  default     = {}
}
variable "private_subnet_tags" {
  description = "Tags to be applied to the private subnets."
  type        = map(string)
  default     = {}
}
variable "vpc_tags" {
  description = "Tags to be applied to the VPC."
  type        = map(string)
  default     = {}
}
variable "tags" {
  description = "A map of tags to add to all resources (including VPC and subnets)."
  type        = map(string)
  default     = {}
}
variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single NAT Gateway for all private subnets (instead of one per private subnet)"
  type        = bool
  default     = false
}
