variable "organizational_units" {
  description = "A list of organizational units to create, each with a name and parent ID."
  type = list(object({
    unit_name = string
    parent_id = string
  }))
  default = []
}