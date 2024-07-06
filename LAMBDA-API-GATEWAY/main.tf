# Configure AWS Provider
provider "aws" {
  region = "us-east-1" # Replace with your desired region
 }

module "current_lambda_module" {
  source       = "./current_lambda_module"
    }

