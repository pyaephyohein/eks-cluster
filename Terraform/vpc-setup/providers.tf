provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}

locals {
  dynamic_tags = {
    ProjectName = var.name
    Environment = var.environment
    Terraform   = "true"
  }
  default_tags = merge(local.dynamic_tags, var.addon_tags)
}