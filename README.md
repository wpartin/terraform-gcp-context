# Usage

Below is an example of how to use this module to create a GCS bucket and GKE clusters with contextual information.

```hcl
module "this" {
  source = "../"

  environment = "test"
  labels      = var.labels
  namespace   = "gke"
  region      = "us-central1"
}

module "bucket_context" {
  source = "../"

  context     = module.this
  namespace   = "gcs"
  environment = module.this.environment
  id          = "data"

  labels = {
    "self-service" = false
  }
}

module "gke_context" {
  source = "../"

  context     = module.this
  environment = module.this.environment

  resources = {
    medplum = {
      id = "phi-datastore"
      labels = {
        team = "all-stars"
      }
    }
    temporal = {
      id = "workflow-engine"
      labels = {
        team = "boogy-bots"
      }
      unit = "engineering"
    }
  }
}

resource "google_storage_bucket" "bucket" {
  location = module.bucket_context.region
  name     = "my-${module.bucket_context.id}-bucket"

  labels = module.bucket_context.labels
}

resource "google_container_cluster" "gke" {
  for_each = module.gke_context.labels

  location = module.gke_context.region
  name     = "my-${each.key}-gke-cluster"

  initial_node_count = 1

  resource_labels = each.value.labels
}
```

Below is an example `terraform plan` output for the above configuration:

```shell
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # google_storage_bucket.bucket will be created
  + resource "google_storage_bucket" "bucket" {
      + effective_labels            = {
          + "goog-terraform-provisioned" = "true"
          + "self-service"               = "false"
        }
      + force_destroy               = false
      + id                          = (known after apply)
      + labels                      = {
          + "self-service" = "false"
        }
      + location                    = "US-CENTRAL1"
      + name                        = "my-data-bucket"
      + project                     = (known after apply)
      + project_number              = (known after apply)
      + public_access_prevention    = (known after apply)
      + rpo                         = (known after apply)
      + self_link                   = (known after apply)
      + storage_class               = "STANDARD"
      + terraform_labels            = {
          + "goog-terraform-provisioned" = "true"
          + "self-service"               = "false"
        }
      + time_created                = (known after apply)
      + uniform_bucket_level_access = (known after apply)
      + updated                     = (known after apply)
      + url                         = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + bucket_context = {
      + delimiter               = "-"
      + enabled                 = true
      + environment             = "test"
      + id                      = "data"
      + ids_full                = {}
      + ids_short               = {}
      + labels                  = {
          + self-service = "false"
        }
      + missing_required_labels = false
      + namespace               = "gcs"
      + region                  = "us-central1"
      + resource_labels         = {}
      + resources               = {}
    }
  + gke_context    = {
      + delimiter               = "-"
      + enabled                 = true
      + environment             = "test"
      + id                      = null
      + ids_full                = {
          + medplum  = "test-usc1-phi-datastore"
          + temporal = "test-usc1-engineering-workflow-engine"
        }
      + ids_short               = {
          + medplum  = "test-usc1-phi"
          + temporal = "test-usc1-eng-wor"
        }
      + labels                  = {}
      + missing_required_labels = false
      + namespace               = ""
      + region                  = "us-central1"
      + resource_labels         = {
          + medplum  = {
              + environment = "test"
              + team        = "all-stars"
              + terraform   = "true"
            }
          + temporal = {
              + environment = "test"
              + team        = "boogy-bots"
              + terraform   = "true"
            }
        }
      + resources               = {
          + medplum  = {
              + enabled           = true
              + environment       = "test"
              + id                = "phi-datastore"
              + id_full           = "test-usc1-phi-datastore"
              + id_length_limit   = 3
              + id_order          = [
                  + "environment",
                  + "region",
                  + "unit",
                  + "namespace",
                  + "id",
                ]
              + id_short          = "test-usc1-phi"
              + labels            = {
                  + environment = "test"
                  + team        = "all-stars"
                  + terraform   = "true"
                }
              + namespace         = ""
              + naming_max_length = null
              + region            = "us-central1"
              + region_short      = "usc1"
              + root_context      = {
                  + enabled         = true
                  + id              = null
                  + id_length_limit = null
                  + id_order        = null
                  + labels          = {
                      + environment = "test"
                      + terraform   = "true"
                    }
                  + namespace       = "gke"
                  + region          = "us-central1"
                  + unit            = null
                }
              + unit              = null
            }
          + temporal = {
              + enabled           = true
              + environment       = "test"
              + id                = "workflow-engine"
              + id_full           = "test-usc1-engineering-workflow-engine"
              + id_length_limit   = 3
              + id_order          = [
                  + "environment",
                  + "region",
                  + "unit",
                  + "namespace",
                  + "id",
                ]
              + id_short          = "test-usc1-eng-wor"
              + labels            = {
                  + environment = "test"
                  + team        = "boogy-bots"
                  + terraform   = "true"
                }
              + namespace         = ""
              + naming_max_length = null
              + region            = "us-central1"
              + region_short      = "usc1"
              + root_context      = {
                  + enabled         = true
                  + id              = null
                  + id_length_limit = null
                  + id_order        = null
                  + labels          = {
                      + environment = "test"
                      + terraform   = "true"
                    }
                  + namespace       = "gke"
                  + region          = "us-central1"
                  + unit            = null
                }
              + unit              = "engineering"
            }
        }
    }
  + this           = {
      + delimiter               = "-"
      + enabled                 = true
      + environment             = "test"
      + id                      = null
      + ids_full                = {}
      + ids_short               = {}
      + labels                  = {
          + environment = "test"
          + terraform   = "true"
        }
      + missing_required_labels = false
      + namespace               = "gke"
      + region                  = "us-central1"
      + resource_labels         = {}
      + resources               = {}
    }
```

# terraform-gcp-context
This module supports contextual information storage and passing within the GCP ecosystem.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0, < 2.0.0 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_context"></a> [context](#input\_context) | The context to use for the resources. If not set, the default context will be used. | <pre>object({<br/>    enabled         = optional(bool)<br/>    id              = optional(string)<br/>    id_length_limit = optional(number)<br/>    id_order        = optional(list(string))<br/>    labels          = optional(map(string))<br/>    namespace       = optional(string)<br/>    region          = optional(string)<br/>    unit            = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | The delimiter to use for separating the ID string components. Either - or \_ | `string` | `"-"` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | A boolean to enable or disable the module | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment for the resources (e.g. dev, prod, staging) | `string` | n/a | yes |
| <a name="input_id"></a> [id](#input\_id) | The ID to use for the resources | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | The maximum lenght of an id when combining the appropriate lables. | `number` | `3` | no |
| <a name="input_id_order"></a> [id\_order](#input\_id\_order) | The order of keys that the resource id should be in. | `list(string)` | <pre>[<br/>  "environment",<br/>  "region",<br/>  "unit",<br/>  "namespace",<br/>  "id"<br/>]</pre> | no |
| <a name="input_labels"></a> [labels](#input\_labels) | A map of labels to add to the resources. Set global label values in the "this" version of the module, and then pass resource specific modifications to "module.this.context". | `map(string)` | `{}` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace for the resources (e.g. app-engine, cloud-functions). | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | The region for the resources (e.g. us-central1, europe-west1). | `string` | `"us-central1"` | no |
| <a name="input_required_labels"></a> [required\_labels](#input\_required\_labels) | List of label keys that must be present on module.labels or per-resource labels. | `list(string)` | <pre>[<br/>  "environment",<br/>  "terraform"<br/>]</pre> | no |
| <a name="input_resources"></a> [resources](#input\_resources) | A map of objects that will define any desired resources. | <pre>map(object({<br/>    enabled           = optional(bool, true)<br/>    id                = string<br/>    id_length_limit   = optional(number)<br/>    id_order          = optional(list(string))<br/>    labels            = optional(map(string), {})<br/>    namespace         = optional(string, "")<br/>    naming_max_length = optional(number)<br/>    region            = optional(string)<br/>    unit              = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_sanitize_names"></a> [sanitize\_names](#input\_sanitize\_names) | Whether to sanitize composed names (lowercase, replace invalid characters with '-') | `bool` | `true` | no |
| <a name="input_service_accounts"></a> [service\_accounts](#input\_service\_accounts) | Optional map of service account definitions that labels can reference. Keyed by logical name. Each object may include create (bool) and roles (list(string)). | <pre>map(object({<br/>    create = optional(bool, false)<br/>    roles  = optional(list(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_unit"></a> [unit](#input\_unit) | The unit identifier that the resources are for. Should be a short-hand identifier. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_delimiter"></a> [delimiter](#output\_delimiter) | The delimiter selected. |
| <a name="output_enabled"></a> [enabled](#output\_enabled) | A boolean to enable or disable the module. |
| <a name="output_environment"></a> [environment](#output\_environment) | The environment for the resources (e.g. dev, prod, staging). |
| <a name="output_id"></a> [id](#output\_id) | The ID to use for the resources. |
| <a name="output_ids_full"></a> [ids\_full](#output\_ids\_full) | Map of resource -> id\_full values |
| <a name="output_ids_short"></a> [ids\_short](#output\_ids\_short) | Map of resource -> id\_short values |
| <a name="output_labels"></a> [labels](#output\_labels) | The labels compiled by the module. |
| <a name="output_missing_required_labels"></a> [missing\_required\_labels](#output\_missing\_required\_labels) | A list of any required labels that are missing from the compiled labels. |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | The appropriate namespace for the resource(s). |
| <a name="output_region"></a> [region](#output\_region) | The GCP region for the resource(s). |
| <a name="output_resource_labels"></a> [resource\_labels](#output\_resource\_labels) | A map of resource -> labels maps that includes all labels applied to each resource. |
| <a name="output_resources"></a> [resources](#output\_resources) | A map of objects that will define any desired resources. |
<!-- END_TF_DOCS -->
