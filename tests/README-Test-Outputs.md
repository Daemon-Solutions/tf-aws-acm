## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|

## Outputs

| Name | Description |
|------|-------------|
| acm\_arn | The ARN of the AWS ACM Certificate. |

## The ACM Cert does not validate in the specified timeout

If the ACM Cert does not validate in the specified timeout period, Terraform will return with the following:
```
1 errorr(s) occurred:

* module.acm_certificate.aws_acm_certificate_validation.cert_dns: 1 error(s) occurred:

* aws_acm_certificate_validation.cert_dns: Expected certificate to be issued but was in state PENDING_VALIDATION
```
In this situation, wait for about 30-45 minutes for DNS propagation and then run another `make plan` and `make apply`
so that terraform can apply the `acm_certificate.aws_acm_certificate_validation.` in the `tfstate` file.

The cause of this is due to DNS propagation times in that it can take up to 30 minutes for the DNS record
to propagate and for the Certificate Manager to resolve the DNS Record (according to AWS).

## Terraform `plan` for a single URL on an ACM Cert.

```
Terraform will perform the following actions:

  + module.acm_certificate.aws_acm_certificate.cert
      id:                          <computed>
      arn:                         <computed>
      domain_name:                 "trynotto.click"
      domain_validation_options.#: <computed>
      validation_emails.#:         <computed>
      validation_method:           "DNS"

  + module.acm_certificate.aws_acm_certificate_validation.acm_dns
      id:                          <computed>
      certificate_arn:             "${aws_acm_certificate.cert.arn}"
      validation_record_fqdns.#:   <computed>

  + module.acm_certificate.aws_route53_record.acm_dns_validation_record
      id:                          <computed>
      allow_overwrite:             <computed>
      fqdn:                        <computed>
      name:                        "${lookup(aws_acm_certificate.cert.domain_validation_options[count.index], \"resource_record_name\")}"
      records.#:                   <computed>
      ttl:                         "60"
      type:                        "${lookup(aws_acm_certificate.cert.domain_validation_options[count.index], \"resource_record_type\")}"
      zone_id:                     "ZW7HC3OXIT5P9"


Plan: 3 to add, 0 to change, 0 to destroy.
```

## Terraform `plan` for multiple URLs with multiple DNS Records (in potentially multiple Route 53 Zones) on an ACM Cert.

```
Terraform will perform the following actions:

  + module.acm_certificate.aws_acm_certificate.cert
      id:                          <computed>
      arn:                         <computed>
      domain_name:                 "trynotto.click"
      domain_validation_options.#: <computed>
      subject_alternative_names.#: "5"
      subject_alternative_names.0: "api.trynotto.click"
      subject_alternative_names.1: "www.trynotto.click"
      subject_alternative_names.2: "stage.trynotto.click"
      subject_alternative_names.3: "api.stage.trynotto.click"
      subject_alternative_names.4: "www.stage.trynotto.click"
      validation_emails.#:         <computed>
      validation_method:           "DNS"

  + module.acm_certificate.aws_acm_certificate_validation.certificate_validation
      id:                          <computed>
      certificate_arn:             "${aws_acm_certificate.cert.arn}"

  + module.acm_certificate.aws_route53_record.dns_validation_record[0]
      id:                          <computed>
      allow_overwrite:             <computed>
      fqdn:                        <computed>
      name:                        "${lookup(aws_acm_certificate.cert.domain_validation_options[count.index], \"resource_record_name\")}"
      records.#:                   <computed>
      ttl:                         "60"
      type:                        "${lookup(aws_acm_certificate.cert.domain_validation_options[count.index], \"resource_record_type\")}"
      zone_id:                     "ZW7HC3OXIT5P9"

  + module.acm_certificate.aws_route53_record.dns_validation_record[1]
      id:                          <computed>
      allow_overwrite:             <computed>
      fqdn:                        <computed>
      name:                        "${lookup(aws_acm_certificate.cert.domain_validation_options[count.index], \"resource_record_name\")}"
      records.#:                   <computed>
      ttl:                         "60"
      type:                        "${lookup(aws_acm_certificate.cert.domain_validation_options[count.index], \"resource_record_type\")}"
      zone_id:                     "ZW7HC3OXIT5P9"

  + module.acm_certificate.aws_route53_record.dns_validation_record[2]
      id:                          <computed>
      allow_overwrite:             <computed>
      fqdn:                        <computed>
      name:                        "${lookup(aws_acm_certificate.cert.domain_validation_options[count.index], \"resource_record_name\")}"
      records.#:                   <computed>
      ttl:                         "60"
      type:                        "${lookup(aws_acm_certificate.cert.domain_validation_options[count.index], \"resource_record_type\")}"
      zone_id:                     "ZW7HC3OXIT5P9"

  + module.acm_certificate.aws_route53_record.dns_validation_record[3]
      id:                          <computed>
      allow_overwrite:             <computed>
      fqdn:                        <computed>
      name:                        "${lookup(aws_acm_certificate.cert.domain_validation_options[count.index], \"resource_record_name\")}"
      records.#:                   <computed>
      ttl:                         "60"
      type:                        "${lookup(aws_acm_certificate.cert.domain_validation_options[count.index], \"resource_record_type\")}"
      zone_id:                     "Z3A73ZVWER7IYF"

  + module.acm_certificate.aws_route53_record.dns_validation_record[4]
      id:                          <computed>
      allow_overwrite:             <computed>
      fqdn:                        <computed>
      name:                        "${lookup(aws_acm_certificate.cert.domain_validation_options[count.index], \"resource_record_name\")}"
      records.#:                   <computed>
      ttl:                         "60"
      type:                        "${lookup(aws_acm_certificate.cert.domain_validation_options[count.index], \"resource_record_type\")}"
      zone_id:                     "Z3A73ZVWER7IYF"

  + module.acm_certificate.aws_route53_record.dns_validation_record[5]
      id:                          <computed>
      allow_overwrite:             <computed>
      fqdn:                        <computed>
      name:                        "${lookup(aws_acm_certificate.cert.domain_validation_options[count.index], \"resource_record_name\")}"
      records.#:                   <computed>
      ttl:                         "60"
      type:                        "${lookup(aws_acm_certificate.cert.domain_validation_options[count.index], \"resource_record_type\")}"
      zone_id:                     "Z3A73ZVWER7IYF"


Plan: 8 to add, 0 to change, 0 to destroy.
```

## Terraform `plan` for email validation.

```
Terraform will perform the following actions:

  + module.acm_certificate.aws_acm_certificate.cert
      id:                          <computed>
      arn:                         <computed>
      domain_name:                 "trynotto.click"
      domain_validation_options.#: <computed>
      subject_alternative_names.#: "5"
      subject_alternative_names.0: "api.trynotto.click"
      subject_alternative_names.1: "www.trynotto.click"
      subject_alternative_names.2: "stage.trynotto.click"
      subject_alternative_names.3: "api.stage.trynotto.click"
      subject_alternative_names.4: "www.stage.trynotto.click"
      validation_emails.#:         <computed>
      validation_method:           "EMAIL"

  + module.acm_certificate.aws_acm_certificate_validation.certificate_validation
      id:                          <computed>
      certificate_arn:             "${aws_acm_certificate.cert.arn}"


Plan: 2 to add, 0 to change, 0 to destroy.
```
