#__________________________________________________________________
#
# Model Data for Domain Profiles and Assigned Policies
#__________________________________________________________________

variable "defaults" {
  description = "Map of Defaults for Intersight Profiles."
  type        = any
}

variable "profiles" {
  description = "Profiles - YAML to HCL data."
  type        = any
}

variable "moids" {
  default     = false
  description = "Flag to Determine if Policies Should be associated using data object or resource."
  type        = bool
}

variable "organization" {
  default     = "default"
  description = "Name of the default intersight Organization."
  type        = string
}

#variable "policies" {
#  description = "Policies Moids."
#  type        = any
#}

variable "tags" {
  default     = []
  description = "List of Key/Value Pairs to Assign as Attributes to the Policy."
  type        = list(map(string))
}