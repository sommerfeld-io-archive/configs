variable "bw_email" {
  type        = string
  description = "Bitwarden Email - Needed for Terraform Provider"
  default     = "sebastian@sommerfeld.io"
}
variable "bw_password" {
  type        = string
  description = "Bitwarden Master Key (Github Actions Secret) - Needed for Terraform Provider"
  sensitive   = true
}
variable "bw_client_id" {
  type        = string
  description = "Bitwarden Client ID (Github Actions Secret) - Needed for Terraform Provider"
  sensitive   = true
}
variable "bw_client_secret" {
  type        = string
  description = "Bitwarden Client Secret (Github Actions Secret) - Needed for Terraform Provider"
  sensitive   = true
}
