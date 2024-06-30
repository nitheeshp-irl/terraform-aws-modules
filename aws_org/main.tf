provider "aws" {
  region = var.aws_region
}

data "aws_organizations_organization" "awsou" {
  # This data source does not require any arguments
}

locals {
  root_id = data.aws_organizations_organization.awsou.roots[0].id
}

# Fetch all OUs in the root account
data "aws_organizations_organizational_units" "existing_ous" {
  parent_id = local.root_id
}

# Create a map of OU names to their IDs
locals {
  parent_ids = { for ou in data.aws_organizations_organizational_units.existing_ous.children : ou.name => ou.id }

  organizational_units = [
    for ou in var.organizational_units : {
      unit_name = ou.unit_name
      parent_id = lookup(local.parent_ids, ou.parent_name, local.root_id)
    }
  ]
}

resource "aws_organizations_organizational_unit" "this" {
  for_each = { for ou in local.organizational_units : ou.unit_name => ou }
  name     = each.value.unit_name
  parent_id = each.value.parent_id
}
