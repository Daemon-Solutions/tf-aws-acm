output "certificate_arn" {
  description = "The ARN of the AWS ACM Certificate."
  value       = module.acm_certificate.certificate_arn
}

output "dns_validation_records" {
  description = "A list of DNS records required for DNS Validation of the ACM Certificate."
  value       = module.acm_certificate.dns_validation_records
}
