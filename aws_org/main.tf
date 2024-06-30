provider "aws" {
  region = var.aws_region
}

data "aws_organizations_organization" "org" {
  # This data source does not require any arguments
}

# Create a map of parent OUs by their names
locals {
  root_id = data.aws_organizations_organization.org.roots[0].id
}

# Create a separate data source for each parent OU to get their IDs
data "aws_organizations_organizational_unit" "parents" {
  for_each = toset([for ou in var.organizational_units : ou.parent_name])
  name     = each.value
  parent_id = local.root_id
}

locals {
  parent_ids = { for name, parent in data.aws_organizations_organizational_unit.parents : name => parent.id }

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
