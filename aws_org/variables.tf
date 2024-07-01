variable "aws_region" {
  description = "The AWS region to create resources in"
  type        = string
  default     = ""
}

variable "organizational_units" {
  description = "List of organizational units"
  default     = ""
  type = list(object({
    unit_name = string
    parent_id = string
  })) 
}
