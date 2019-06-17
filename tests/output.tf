output "certificate_arn" {
  description = "The ARN of the AWS ACM Certificate."
  value       = module.acm_certificate.certificate_arn
}
