terraform {
  backend "s3" {
    bucket  = "task4-terraform-backend-12345678"
    key     = "eks-gitops/terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}