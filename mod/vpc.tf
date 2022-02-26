data "aws_availability_zones" "available" {}

module "tmp_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.6.0"

  name                 = "tmp_VPC"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.0.0/21", "10.0.8.0/21"]
}