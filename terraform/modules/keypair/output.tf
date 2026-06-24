output "key_pair_name" {
  description = "The name of the key pair"
  value       = module.keypair.key_pair_name
}
output "private_key_path" {
  description = "The path to the private key file"
  value       = module.keypair.private_key_path
}