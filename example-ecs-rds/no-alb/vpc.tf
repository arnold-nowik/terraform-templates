module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "example-stg-vpc"
  cidr = "10.16.0.0/16"

  azs              = [join("", [local.region, "a"]), join("", [local.region, "c"])]
  database_subnets = ["10.16.1.0/24", "10.16.2.0/24"]
  public_subnets   = ["10.16.101.0/24", "10.16.102.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "stg"
  }
}
