output "certificate_arn" {
  description = "The ARN of the AWS ACM Certificate, only returned when wait_for_validation = true to prevent usage of invalid certificates."
  value       = "${join("", aws_acm_certificate_validation.certificate_validation.*.certificate_arn)}"
}
