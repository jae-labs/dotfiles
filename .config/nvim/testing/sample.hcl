// Sample HCL configuration file for testing

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "sample-project"
}

// Variable without description
type variable "invalid_type" {
  type = invalid_hcl_type
}

locals {
  common_tags = {
    Project     = var.project_name
    Environment = "development"
    ManagedBy   = "terraform"
  }

  cidr_blocks = {
    primary = "10.0.0.0/16"
    secondary = "10.1.0.0/16"
  }

  // Unused local
  unused_local = "this is not used"

  // Invalid syntax - missing equals
  bad_local "no equals sign"
}

resource "aws_vpc" "main" {
  cidr_block           = local.cidr_blocks.primary
  enable_dns_hostnames = true
  enable_dns_support   = true

  // Missing tags description
  tags = merge(local.common_tags, {
    Name = "${var.project_name}-vpc"
  })
}

// Resource with invalid reference
resource "aws_subnet" "bad" {
  vpc_id     = aws_vpc.nonexistent.id  // Invalid reference
  cidr_block = "10.0.100.0/24"
}

module "security_groups" {
  source = "./modules/security-groups"

  vpc_id = aws_vpc.main.id
  project_name = var.project_name

  tags = local.common_tags

  // Invalid module argument
  invalid_arg = "this doesn't exist"
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "security_group_ids" {
  description = "Security group IDs"
  value       = module.security_groups.sg_ids
}

// Output without description
output "bad_output" {
  value = "no description"
}

// Duplicate output
output "vpc_id" {
  description = "Duplicate VPC ID"
  value       = aws_vpc.main.id
}
