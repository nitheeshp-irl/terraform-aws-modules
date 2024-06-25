variable "organizational_units" {
  description = "List of organizational units to create"
  type = list(object({
    unit_name = string
    parent_id = string
  }))
}