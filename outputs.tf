output "certificate_arn" {
  description = "The ARN of the AWS ACM Certificate."
  value = join("", aws_acm_certificate.cert.*.arn)
}

output "dns_validation_records" {
  description = "A list of DNS records required for DNS Validation of the ACM Certificate."
  value       = join("", aws_acm_certificate.cert.*.domain_validation_options)
}
