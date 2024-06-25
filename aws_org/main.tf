resource "aws_organizations_organizational_unit" "unit" {
  for_each = { for ou in var.organizational_units : ou.unit_name => ou }

  name      = each.value.unit_name
  parent_id = each.value.parent_id
}