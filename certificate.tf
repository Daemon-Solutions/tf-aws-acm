provider "aws" {
  alias = "r53"
}

provider "aws" {
  alias = "acm"
}

data "template_file" "domain_names" {
  count    = "${var.enabled ? var.domains_count : 0}"
  template = "${lookup(var.domains[count.index], "name")}"
}

locals {
  domain_names = ["${data.template_file.domain_names.*.rendered}"]
}

resource "aws_acm_certificate" "cert" {
  count                     = "${var.enabled ? 1 : 0}"
  provider                  = "aws.acm"
  domain_name               = "${lookup(var.domains[0], "name")}"
  subject_alternative_names = ["${slice(local.domain_names, 1, length(local.domain_names))}"]
  validation_method         = "${var.validation_method}"
  tags                      = "${var.tags}"
}

resource "aws_route53_record" "dns_validation_record" {
  count    = "${var.enabled && var.create_dns_records && var.validation_method == "DNS" ? length(var.domains) : 0}"
  provider = "aws.r53"
  zone_id  = "${lookup(var.domains[count.index], "zone_id")}"
  name     = "${lookup(aws_acm_certificate.cert.domain_validation_options[count.index], "resource_record_name")}"
  type     = "${lookup(aws_acm_certificate.cert.domain_validation_options[count.index], "resource_record_type")}"
  ttl      = "${var.ttl}"

  records = [
    "${lookup(aws_acm_certificate.cert.domain_validation_options[count.index], "resource_record_value")}",
  ]
}

resource "aws_acm_certificate_validation" "certificate_validation" {
  count           = "${var.enabled && var.wait_for_validation ? 1 : 0}"
  provider        = "aws.acm"
  certificate_arn = "${aws_acm_certificate.cert.arn}"

  timeouts {
    create = "${var.timeout}m"
  }
}
