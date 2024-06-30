locals {
  root_id = data.aws_organizations_organization.awsou.roots[0].id
}

variable "organizational_units" {
  description = "List of organizational units"
  type = list(object({
    unit_name = string
    parent_id = string
  }))
  default = [
    {
      unit_name = "infra"
      parent_id = local.root_id
    },
    {
      unit_name = "apps"
      parent_id = local.root_id
    }
  ]
}

