output "name" {
  description = "Name of the VPC"
  value       = module.vpc.name
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_arn" {
  description = "ARN of the VPC"
  value       = module.vpc.vpc_arn
}

output "vpc_cidr_block" {
  description = "Primary IPv4 CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnets
}

output "nat_gateway_ids" {
  description = "IDs of the NAT Gateways"
  value       = module.vpc.natgw_ids
}

output "nat_gateway_public_ips" {
  description = "Public Elastic IP addresses assigned to the NAT Gateways"
  value       = module.vpc.nat_public_ips
}

output "igw_id" {
  description = "ID of the Internet Gateway, or null when one is not created"
  value       = module.vpc.igw_id
}

output "public_route_table_ids" {
  description = "IDs of the public route tables"
  value       = module.vpc.public_route_table_ids
}

output "private_route_table_ids" {
  description = "IDs of the private route tables"
  value       = module.vpc.private_route_table_ids
}

output "route_table_ids" {
  description = "IDs of all public and private route tables"
  value       = concat(module.vpc.public_route_table_ids, module.vpc.private_route_table_ids)
}

output "availability_zones" {
  description = "Availability zones used by the VPC subnets"
  value       = module.vpc.azs
}
