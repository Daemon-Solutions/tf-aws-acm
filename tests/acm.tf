provider "aws" {
  alias  = "cloudfront"
  region = "us-east-1"
}

module "acm_certificate" {
  source = "../"

  providers = {
    aws = aws.cloudfront
  }

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
      zone_id = "Z3Q5JMOREGM7ER"
    },
    {
      name    = "api.stage.trynotto.click"
      zone_id = "Z3Q5JMOREGM7ER"
    },
    {
      name    = "www.stage.trynotto.click"
      zone_id = "Z3Q5JMOREGM7ER"
    },
  ]

  domains_count = 6
}
