# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket    = "aojomoh-terraform-remote-state"
    key       = "alex-website-ecs.tfstate"
    region    = "us-east-1"
    profile   = "test-user"
  }
}