terraform {
  backend "s3" {
    bucket         = "terraform-for-scalability"
    key            = "shared/terraform.tfstate"
    region         = "eu-west-1"
    profile        = "theodo-perso"
    dynamodb_table = "terraform-lock"
  }
}
