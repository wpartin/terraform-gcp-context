variable "context" {
  description = "The context to use for the resources. If not set, the default context will be used."
  type        = object({
    enabled         = optional(bool, true)
    id              = optional(string)
    id_length_limit = optional(number)
    labels          = optional(map(string), {})
    label_order     = optional(list(string))
    namespace       = optional(string)
    region          = optional(string)
    unit            = optional(string)
  })
  default     = {}
}

variable "delimiter" {
  description = "The delimiter to use for separating the ID string components. Either - or _"
  type        = string
  default     = "-"

  validation {
    condition     = contains(["-", "_"], var.delimiter)
    error_message = "The delimiter must be either '-' or '_'."
  }
}

variable "enabled" {
  description = "A boolean to enable or disable the module"
  type        = bool
  default     = true
}

variable "environment" {
  description = "The environment for the resources (e.g. dev, prod, staging)"
  type        = string

  validation {
    condition     = length(var.environment) > 0
    error_message = "The environment variable must not be empty."
  }
}

variable "id" {
  description = "The ID to use for the resources"
  type        = string
  default     = null
}

variable "id_length_limit" {
  description = "The maximum lenght of an id when combining the appropriate lables."
  type        = number
  default     = 3

  validation {
    condition     = var.id_length_limit > 0 && var.id_length_limit < 12
    error_message = "The id_length_limit variable must be greater than 0 and less than 12."
  }
}

variable "id_order" {
  description = "The order of keys that the resource id should be in."
  type        = list(string)
  default     = ["environment", "region", "unit", "namespace", "id"]
}

variable "labels" {
  description = "A map of labels to add to the resources. Set global label values in the \"this\" version of the module, and then pass resource specific modifications to \"module.this.context\"."
  type        = map(string)
  default     = {}
}

variable "namespace" {
  description = "The namespace for the resources (e.g. app-engine, cloud-functions)."
  type        = string
  default     = ""
}

variable "region" {
  description = "The region for the resources (e.g. us-central1, europe-west1)."
  type        = string
  default     = "us-central1"

  validation {
    condition     = var.region != null ? contains(["us-central1", "us-east1", "us-east4", "us-west1", "us-west2"], var.region) : true
    error_message = "The region must be one of the following: us-central1, us-east1, us-east4, us-west1, us-west2."
  }
}

variable "required_labels" {
  description = "List of label keys that must be present on module.labels or per-resource labels."
  type        = list(string)
  default     = ["environment", "terraform"]
}

variable "resources" {
  description = "A map of objects that will define any desired resources."
  type = map(object({
    enabled         = optional(bool, true)
    id              = string
    id_length_limit = optional(number)
    label_order     = optional(list(string))
    namespace       = optional(string, "")
    region          = optional(string)
    unit            = optional(string)
    tags            = optional(map(string), {})
  }))
  default = {}
}

variable "sanitize_names" {
  description = "Whether to sanitize composed names (lowercase, replace invalid characters with '-')"
  type        = bool
  default     = true
}

variable "service_accounts" {
  description = "Optional map of service account definitions that labels can reference. Keyed by logical name. Each object may include create (bool) and roles (list(string))."
  type = map(object({
    create = optional(bool, false)
    roles  = optional(list(string), [])
  }))
  default = {}
}

variable "unit" {
  description = "The unit identifier that the resources are for. Should be a short-hand identifier."
  type        = string
  default     = null
}
