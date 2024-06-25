variable "organizational_units" {
  description = "A list of organizational units"
  type = list(object({
    unit_name = string
    parent_id = string
  }))
}