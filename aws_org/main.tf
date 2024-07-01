variable "aws_region" {
  description = "The AWS region to create resources in"
  type        = string
}

variable "organizational_units" {
  description = "List of organizational units"
  type = list(object({
    unit_name = string
    parent_id = string
  }))
}

provider "aws" {
  region = var.aws_region
}

resource "aws_organization_unit" "example" {
  for_each = { for ou in var.organizational_units : ou.unit_name => ou }

  name     = each.value.unit_name
  parent_id = each.value.parent_id
}
