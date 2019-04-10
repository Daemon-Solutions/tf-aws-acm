provider "aws" {
  alias  = "cloudfront"
  region = "us-east-1"
}

module "acm_certificate" {
  source = "../"

  providers = {
    aws = "aws.cloudfront"
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
      zone_id = "Z3A73ZVWER7IYF"
    },
    {
      name    = "api.stage.trynotto.click"
      zone_id = "Z3A73ZVWER7IYF"
    },
    {
      name    = "www.stage.trynotto.click"
      zone_id = "Z3A73ZVWER7IYF"
    },
  ]

  domains_count = 6
}
