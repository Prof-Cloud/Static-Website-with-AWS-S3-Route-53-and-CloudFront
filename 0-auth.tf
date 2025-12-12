terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.25.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"


  default_tags {
    tags = {
      TeamMember  = "Prof Cloud"
      ManagedBy   = "Terraform"
      Environment = "Dev"
      Location    = "London"
    }
  }
}

provider "aws" {
  # CloudFront requires SSL certificates to be provisioned in us-east-1 region
  alias  = "acm_provider"
  region = "us-east-1"

  default_tags {
    tags = {
      TeamMember  = "Prof Cloud"
      ManagedBy   = "Terraform"
      Environment = "Dev"
      Location    = "North Virigina"
    }
  }
}