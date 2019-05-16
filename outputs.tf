output "certificate_arn" {
  description = "The ARN of the AWS ACM Certificate."
  value       = "${join("", coalescelist(aws_acm_certificate_validation.certificate_validation.*.certificate_arn, aws_acm_certificate.cert.*.arn))}"
}
