variable key_pair_name {
  description = "The name of the key pair to use for the instance"
  type        = string
}
variable iam_secrets_name {
  description = "Name of the Secrets Manager secret for storing IAM credential"
  type        = string
  default     = ""
}
variable iam_tags {
  description = "Tags to apply to IAM user and secret"
  type        = map(string)
  default     = {}
}
variable iam_user_name {
  description = "The name of the IAM user to create"
  type        = string
  default     = ""
}
variable rsa_bits {
  description = "The number of bits in the RSA key"
  type        = number
  default     = 4096
}
variable secrets_description {
  description = "The description of the IAM secret"
  type        = string
  default     = ""
}
variable secretsmanager_name {
  description = "Name of the Secrets Manager secret for storing the PEM file"
  type        = string
  default     = ""
}