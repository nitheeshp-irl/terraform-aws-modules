output "organizational_unit_ids" {
  description = "The IDs of the created organizational units"
  value       = { for ou in aws_organizations_organizational_unit.unit : ou.name => ou.id }
}