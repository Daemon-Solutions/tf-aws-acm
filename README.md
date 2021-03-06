# tf-aws-acm

 This will create an ACM certificate in a specified region and creates the Route 53 DNS records if DNS validation is selected and if the DNS Zone File is located in AWS Route 53.

## Usage

### Certificate with a single domain

```js
provider "aws" {
  alias  = "dns-account"

  assume_role {
    role_arn = "arn:aws:iam::123345678901:role/dns-management-role"
  }
}


module "acm_certificate" {
  source = "../"

  domains = [
    {
      name    = "trynotto.click"
      zone_id = "ZW7HC3OXIT5P9"
    }
  ]

  domains_count = 1

  # different providers for ACM and DNS resources
  providers = {
    aws.acm = "aws"
    aws.r53 = "aws.dns-account"
  }
}
```

### Certificate in a different region

```js
provider "aws" {
  alias  = "cloudfront"
  region = "us-east-1"
}


module "acm_certificate" {
  source = "../"

  domains = [
    {
      name    = "trynotto.click"
      zone_id = "ZW7HC3OXIT5P9"
    }
  ]

  domains_count = 1

  # different providers for ACM and DNS resources
  providers = {
    aws.acm = "aws.cloudfront"
    aws.r53 = "aws"
  }
}
```

### Certificate with multiple domains

```js
module "acm_certificate" {
  source = "../"

  domains = [
    {
      name    = "trynotto.click"
      zone_id = "ZW7HC3OXIT5P9"
    },
    {
      name    = "api.trynotto.click"
      zone_id = "ZW7HC3OXIT5P9"
    },
    {
      name    = "www.trynotto.click"
      zone_id = "ZW7HC3OXIT5P9"
    },
    {
      name    = "stage.trynotto.click"
      zone_id = "Z33RTPZPQU0IR5"
    },
    {
      name    = "api.stage.trynotto.click"
      zone_id = "Z33RTPZPQU0IR5"
    },
    {
      name    = "www.stage.trynotto.click"
      zone_id = "Z33RTPZPQU0IR5"
    },
  ]

  domains_count = 6

  # the same provider for ACM and DNS resources
  providers = {
    aws.acm = "aws"
    aws.r53 = "aws"
  }
}
```
### Certificate with email validation

```js
module "acm_certificate" {
  source = "../"

  domains = [
    {
      name = "trynotto.click"
    },
    {
      name = "api.trynotto.click"
    },
    {
      name = "www.trynotto.click"
    },
    {
      name = "stage.trynotto.click"
    },
    {
      name = "api.stage.trynotto.click"
    },
    {
      name = "www.stage.trynotto.click"
    },
  ]

  domains_count = 6

  wait_for_validation = false

  validation_method = "EMAIL"

  providers = {
    aws.acm = "aws"
    aws.r53 = "aws"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create\_dns\_records | Create the DNS records in Route53. | string | `"true"` | no |
| domains | List of maps of domains to associate with the new certificate. For example: domains = [ { name = "www.example.com"  zone_id = "Z123456789" } ] | list | n/a | yes |
| domains\_count | Length of domains list - because count cannot be calculated on computed values. | string | n/a | yes |
| enabled | Enable or disable the resources. | string | `"true"` | no |
| timeout | The length of time in minutes Terraform should wait for to allow AWS to validate the ACM Certificate. | string | `"45"` | no |
| ttl | The time-to-live for the DNS record. | string | `"60"` | no |
| validation\_method | The method of validation for the ACM Cert. The allowed values are DNS and EMAIL | string | `"DNS"` | no |
| wait\_for\_validation | Wait for the certificate to be validated. | string | `"true"` | no |
| tags | Map of tags for certificate. | map | `{}` | no |


You always have to pass `providers` block with two providers:
- `aws.acm` - for ACM related resources.
- `aws.r53` - for DNS related resources

In case you want all resources created with the same provider simply pass the same provider:

```
providers = {
  aws.acm = "aws"
  aws.r53 = "aws"
}
```

## Outputs

| Name | Description |
|------|-------------|
| certificate\_arn | The ARN of the AWS ACM Certificate, only returned when wait_for_validation = true to prevent usage of invalid certificates. |

## References

The following AWS Documentation was used as references:

https://www.terraform.io/docs/providers/aws/r/acm_certificate.html

https://www.terraform.io/docs/providers/aws/r/acm_certificate_validation.html

https://www.terraform.io/docs/providers/aws/d/acm_certificate.html
