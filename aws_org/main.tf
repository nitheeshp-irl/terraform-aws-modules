provider "aws" {
  region = var.aws_region
}

data "aws_organizations_organization" "org" {
  # This data source does not require any arguments
}

locals {
  root_id = data.aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_organizational_unit" "parent" {
  for_each = {
    for ou in var.organizational_units : ou.parent_name => ou if ou.parent_name != "root"
  }
  name     = each.key
  parent_id = local.root_id
}

locals {
  parent_ids = merge(
    { root = local.root_id },
    { for k, v in aws_organizations_organizational_unit.parent : k => v.id }
  )

  organizational_units = [
    for ou in var.organizational_units : {
      unit_name = ou.unit_name
      parent_id = local.parent_ids[ou.parent_name]
    }
  ]
}

resource "aws_organizations_organizational_unit" "this" {
  for_each = { for ou in local.organizational_units : ou.unit_name => ou }
  name     = each.value.unit_name
  parent_id = each.value.parent_id
}
