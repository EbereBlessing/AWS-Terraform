terraform {
  backend "s3" {
    bucket = "terraform-statefile2bo"
    key    = "terraform.tfstate"
    region = "us-west-2"
    dynamodb_table = "Terraform-statefile" 
  }
}