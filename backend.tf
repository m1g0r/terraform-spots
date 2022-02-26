terraform {
  backend "s3" {
    bucket = "tmp-terraform-state"
    key    = "env/tmp/terraform.tfstate"
    region = "eu-central-1"

    encrypt = "true"
    acl = "private"
  }
}
