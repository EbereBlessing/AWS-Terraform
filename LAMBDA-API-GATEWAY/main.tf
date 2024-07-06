# Configure AWS Provider
provider "aws" {
  region = "us-west-2" # Replace with your desired region
 }

module "current_lambda_module" {
  source       = "./current_lambda_module"
    }

module "updated_lambda_module" {
  source       = "./updated_lambda_module"
    }