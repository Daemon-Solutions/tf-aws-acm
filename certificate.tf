provider "aws" {
  alias = "r53"
}

provider "aws" {
  alias = "acm"
}

data "template_file" "domain_names" {
  count    = var.enabled ? var.domains_count : 0
  template = var.domains[count.index]["name"]
}

data "template_file" "zone_ids" {
  count    = var.enabled ? var.domains_count : 0
  template = var.domains[count.index]["zone_id"]
}

locals {
  domain_names             = tolist(data.template_file.domain_names.*.rendered)
  zone_ids                 = tolist(data.template_file.zone_ids.*.rendered)
  domains_and_zone_ids_map = zipmap(local.domain_names, local.zone_ids)
}

resource "aws_acm_certificate" "cert" {
  count       = var.enabled ? 1 : 0
  provider    = aws.acm
  domain_name = var.domains[0]["name"]
  subject_alternative_names = slice(local.domain_names, 1, length(local.domain_names))
  validation_method         = var.validation_method
  tags                      = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "dns_validation_record" {
  count           = var.enabled && var.create_dns_records && var.validation_method == "DNS" ? var.domains_count : 0
  provider        = aws.r53
  allow_overwrite = true
  zone_id         = lookup(local.domains_and_zone_ids_map, "${lookup(aws_acm_certificate.cert.0.domain_validation_options[count.index], "domain_name")}.")
  name            = aws_acm_certificate.cert.0.domain_validation_options[count.index].resource_record_name
  type            = aws_acm_certificate.cert.0.domain_validation_options[count.index].resource_record_type
  ttl             = var.ttl

  records = [
    aws_acm_certificate.cert.0.domain_validation_options[count.index]["resource_record_value"],
  ]
}

resource "aws_acm_certificate_validation" "certificate_validation" {
  count           = var.enabled && var.wait_for_validation ? 1 : 0
  provider        = aws.acm
  certificate_arn = aws_acm_certificate.cert[0].arn

  timeouts {
    create = "${var.timeout}m"
  }
}
