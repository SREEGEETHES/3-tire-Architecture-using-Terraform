terraform {
  backend "s3" {
    bucket         = "Sree-geethesh-terraform-backend"
    encrypt        = true
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "Sree-geethesh-terraform-backend"
  }
}