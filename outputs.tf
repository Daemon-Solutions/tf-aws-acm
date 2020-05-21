output "certificate_arn" {
  description = "The ARN of the AWS ACM Certificate."
  value = aws_acm_certificate_validation.certificate_validation.*.certificate_arn != [] || aws_acm_certificate.cert.*.arn != [] ? coalescelist(
      aws_acm_certificate_validation.certificate_validation.*.certificate_arn,
      aws_acm_certificate.cert.*.arn,
    ) : []
}

output "dns_validation_records" {
  description = "A list of DNS records required for DNS Validation of the ACM Certificate."
  value       = length(aws_acm_certificate.cert) > 0 ? flatten(aws_acm_certificate.cert.0.domain_validation_options[*]) : []
}
