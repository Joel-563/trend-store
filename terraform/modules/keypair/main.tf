module "keypair" {
  source  = "thomasvjoseph/keypair/aws"
  version = "1.1.4"
  key_pair_name = var.key_pair_name
  rsa_bits = var.rsa_bits
}