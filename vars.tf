variable "create_dns_records" {
  description = "Create the DNS records in Route53."
  default     = true
}

variable "domains" {
  description = "List of maps of domains to associate with the new certificate. For example: domains = [ { name = \"www.example.com\"  zone_id = \"Z123456789\" } ]"
  type        = "list"
}

variable "domains_count" {
  description = "Length of domains list - because count cannot be calculated on computed values."
}

variable "enabled" {
  description = "Enable or disable the resources."
  default     = true
}

variable "timeout" {
  description = "The length of time in minutes Terraform should wait for to allow AWS to validate the ACM Certificate."
  type        = "string"
  default     = "45"
}

variable "ttl" {
  description = "The time-to-live for the DNS record."
  type        = "string"
  default     = "60"
}

variable "validation_method" {
  description = "The method of validation for the ACM Cert. The allowed values are DNS and EMAIL"
  type        = "string"
  default     = "DNS"
}

variable "wait_for_validation" {
  description = "Wait for the certificate to be validated."
  default     = true
}

variable "tags" {
  description = "Tags for the certificate."
  type        = "map"
  default     = {}
}
