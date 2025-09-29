# Usage

Below is an example of how to use this module to create a GCS bucket and GKE clusters with contextual information.

```hcl
module "this" {
  source = "../"

  environment = "test"
  namespace   = "gke"
  region      = "us-central1"

  tags = {
    terraform   = "true"
    environment = "test"
  }
}

module "bucket_context" {
  source = "../"

  context     = module.this
  namespace   = "gcs"
  environment = module.this.environment

  tags = {
    terraform      = "true"
    environment    = "test"
    "self-service" = false
  }
}

module "gke_context" {
  source = "../"

  context     = module.this
  environment = module.this.environment

  labels = {
    medplum = {
      id   = "phi-datastore"
      tags = {
        team = "all-stars"
      }
    }
    temporal = {
      id   = "workflow-engine"
      tags = {
        team = "boogy-bots"
      }
    }
  }
}

resource "google_storage_bucket" "bucket" {
  location = module.bucket_context.region
  name     = "my-bucket"

  labels = module.bucket_context.tags
}

resource "google_container_cluster" "gke" {
  for_each = module.gke_context.labels

  location = module.gke_context.region
  name     = "my-${each.key}-gke-cluster"

  initial_node_count = 1

  resource_labels = each.value.tags
}
```

Below is an example `terraform plan` output for the above configuration:

```shell
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  + create

Terraform will perform the following actions:

  # google_container_cluster.gke["medplum"] will be created
  + resource "google_container_cluster" "gke" {
      + cluster_ipv4_cidr                        = (known after apply)
      + datapath_provider                        = (known after apply)
      + default_max_pods_per_node                = (known after apply)
      + deletion_protection                      = true
      + disable_l4_lb_firewall_reconciliation    = false
      + effective_labels                         = {
          + "environment"                = "test"
          + "goog-terraform-provisioned" = "true"
          + "self-service"               = "false"
          + "team"                       = "all-stars"
          + "terraform"                  = "true"
        }
      + enable_cilium_clusterwide_network_policy = false
      + enable_fqdn_network_policy               = false
      + enable_intranode_visibility              = (known after apply)
      + enable_kubernetes_alpha                  = false
      + enable_l4_ilb_subsetting                 = false
      + enable_legacy_abac                       = false
      + enable_multi_networking                  = false
      + enable_shielded_nodes                    = true
      + endpoint                                 = (known after apply)
      + id                                       = (known after apply)
      + initial_node_count                       = 1
      + label_fingerprint                        = (known after apply)
      + location                                 = "us-central1"
      + logging_service                          = (known after apply)
      + master_version                           = (known after apply)
      + monitoring_service                       = (known after apply)
      + name                                     = "my-medplum-gke-cluster"
      + network                                  = "default"
      + networking_mode                          = (known after apply)
      + node_locations                           = (known after apply)
      + node_version                             = (known after apply)
      + operation                                = (known after apply)
      + private_ipv6_google_access               = (known after apply)
      + project                                  = (known after apply)
      + resource_labels                          = {
          + "environment"  = "test"
          + "self-service" = "false"
          + "team"         = "all-stars"
          + "terraform"    = "true"
        }
      + self_link                                = (known after apply)
      + services_ipv4_cidr                       = (known after apply)
      + subnetwork                               = (known after apply)
      + terraform_labels                         = {
          + "environment"                = "test"
          + "goog-terraform-provisioned" = "true"
          + "self-service"               = "false"
          + "team"                       = "all-stars"
          + "terraform"                  = "true"
        }
      + tpu_ipv4_cidr_block                      = (known after apply)
    }

  # google_container_cluster.gke["temporal"] will be created
  + resource "google_container_cluster" "gke" {
      + cluster_ipv4_cidr                        = (known after apply)
      + datapath_provider                        = (known after apply)
      + default_max_pods_per_node                = (known after apply)
      + deletion_protection                      = true
      + disable_l4_lb_firewall_reconciliation    = false
      + effective_labels                         = {
          + "environment"                = "test"
          + "goog-terraform-provisioned" = "true"
          + "self-service"               = "false"
          + "team"                       = "boogy-bots"
          + "terraform"                  = "true"
        }
      + enable_cilium_clusterwide_network_policy = false
      + enable_fqdn_network_policy               = false
      + enable_intranode_visibility              = (known after apply)
      + enable_kubernetes_alpha                  = false
      + enable_l4_ilb_subsetting                 = false
      + enable_legacy_abac                       = false
      + enable_multi_networking                  = false
      + enable_shielded_nodes                    = true
      + endpoint                                 = (known after apply)
      + id                                       = (known after apply)
      + initial_node_count                       = 1
      + label_fingerprint                        = (known after apply)
      + location                                 = "us-central1"
      + logging_service                          = (known after apply)
      + master_version                           = (known after apply)
      + monitoring_service                       = (known after apply)
      + name                                     = "my-temporal-gke-cluster"
      + network                                  = "default"
      + networking_mode                          = (known after apply)
      + node_locations                           = (known after apply)
      + node_version                             = (known after apply)
      + operation                                = (known after apply)
      + private_ipv6_google_access               = (known after apply)
      + project                                  = (known after apply)
      + resource_labels                          = {
          + "environment"  = "test"
          + "self-service" = "false"
          + "team"         = "boogy-bots"
          + "terraform"    = "true"
        }
      + self_link                                = (known after apply)
      + services_ipv4_cidr                       = (known after apply)
      + subnetwork                               = (known after apply)
      + terraform_labels                         = {
          + "environment"                = "test"
          + "goog-terraform-provisioned" = "true"
          + "self-service"               = "false"
          + "team"                       = "boogy-bots"
          + "terraform"                  = "true"
        }
      + tpu_ipv4_cidr_block                      = (known after apply)
    }

  # google_storage_bucket.bucket will be created
  + resource "google_storage_bucket" "bucket" {
      + effective_labels            = {
          + "environment"                = "test"
          + "goog-terraform-provisioned" = "true"
          + "self-service"               = "false"
          + "terraform"                  = "true"
        }
      + force_destroy               = false
      + id                          = (known after apply)
      + labels                      = {
          + "environment"  = "test"
          + "self-service" = "false"
          + "terraform"    = "true"
        }
      + location                    = "US-CENTRAL1"
      + name                        = "my-bucket"
      + project                     = (known after apply)
      + project_number              = (known after apply)
      + public_access_prevention    = (known after apply)
      + rpo                         = (known after apply)
      + self_link                   = (known after apply)
      + storage_class               = "STANDARD"
      + terraform_labels            = {
          + "environment"                = "test"
          + "goog-terraform-provisioned" = "true"
          + "self-service"               = "false"
          + "terraform"                  = "true"
        }
      + time_created                = (known after apply)
      + uniform_bucket_level_access = (known after apply)
      + updated                     = (known after apply)
      + url                         = (known after apply)
    }

Plan: 3 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + bucket_context = {
      + delimiter   = "-"
      + enabled     = true
      + environment = "test"
      + id          = null
      + labels      = {}
      + namespace   = "gcs"
      + region      = "us-central1"
      + tags        = {
          + environment  = "test"
          + self-service = "false"
          + terraform    = "true"
        }
    }
  + gke_context    = {
      + delimiter   = "-"
      + enabled     = true
      + environment = "test"
      + id          = null
      + labels      = {
          + medplum  = {
              + enabled         = true
              + environment     = "test"
              + id              = "phi-datastore"
              + id_full         = "test-usc1-phi-datastore"
              + id_length_limit = 3
              + id_short        = "test-usc1-phi-datastore"
              + label_order     = [
                  + "environment",
                  + "region",
                  + "unit",
                  + "namespace",
                  + "id",
                ]
              + namespace       = ""
              + region          = "us-central1"
              + region_short    = "usc1"
              + root_context    = {
                  + enabled         = true
                  + id              = null
                  + id_length_limit = null
                  + label_order     = null
                  + namespace       = "gke"
                  + region          = "us-central1"
                  + tags            = {
                      + environment = "test"
                      + terraform   = "true"
                    }
                  + unit            = null
                }
              + tags            = {
                  + environment  = "test"
                  + self-service = "false"
                  + team         = "all-stars"
                  + terraform    = "true"
                }
              + unit            = null
            }
          + temporal = {
              + enabled         = true
              + environment     = "test"
              + id              = "workflow-engine"
              + id_full         = "test-usc1-workflow-engine"
              + id_length_limit = 3
              + id_short        = "test-usc1-workflow-engine"
              + label_order     = [
                  + "environment",
                  + "region",
                  + "unit",
                  + "namespace",
                  + "id",
                ]
              + namespace       = ""
              + region          = "us-central1"
              + region_short    = "usc1"
              + root_context    = {
                  + enabled         = true
                  + id              = null
                  + id_length_limit = null
                  + label_order     = null
                  + namespace       = "gke"
                  + region          = "us-central1"
                  + tags            = {
                      + environment = "test"
                      + terraform   = "true"
                    }
                  + unit            = null
                }
              + tags            = {
                  + environment  = "test"
                  + self-service = "false"
                  + team         = "boogy-bots"
                  + terraform    = "true"
                }
              + unit            = null
            }
        }
      + namespace   = ""
      + region      = "us-central1"
      + tags        = {
          + environment  = "test"
          + self-service = "false"
          + terraform    = "true"
        }
    }
  + this           = {
      + delimiter   = "-"
      + enabled     = true
      + environment = "test"
      + id          = null
      + labels      = {}
      + namespace   = "gke"
      + region      = "us-central1"
      + tags        = {
          + environment = "test"
          + terraform   = "true"
        }
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
| <a name="input_context"></a> [context](#input\_context) | The context to use for the resources. If not set, the default context will be used. | <pre>object({<br/>    enabled         = optional(bool, true)<br/>    id              = optional(string)<br/>    id_length_limit = optional(number)<br/>    label_order     = optional(list(string))<br/>    namespace       = optional(string)<br/>    region          = optional(string)<br/>    unit            = optional(string)<br/>    tags            = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | The delimiter to use for separating the ID string components. Either - or \_ | `string` | `"-"` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | A boolean to enable or disable the module | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment for the resources (e.g. dev, prod, staging) | `string` | n/a | yes |
| <a name="input_id"></a> [id](#input\_id) | The ID to use for the resources | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | The maximum lenght of an id when combining the appropriate lables. | `number` | `3` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order that the resource labels should be in. | `list(string)` | <pre>[<br/>  "environment",<br/>  "region",<br/>  "unit",<br/>  "namespace",<br/>  "id"<br/>]</pre> | no |
| <a name="input_labels"></a> [labels](#input\_labels) | A map of objects that will define any desired labels. | <pre>map(object({<br/>    enabled         = optional(bool, true)<br/>    id              = string<br/>    id_length_limit = optional(number)<br/>    label_order     = optional(list(string))<br/>    namespace       = optional(string, "")<br/>    region          = optional(string)<br/>    unit            = optional(string)<br/>    tags            = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace for the resources (e.g. app-engine, cloud-functions). | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | The region for the resources (e.g. us-central1, europe-west1). | `string` | `"us-central1"` | no |
| <a name="input_required_tags"></a> [required\_tags](#input\_required\_tags) | List of tag keys that must be present on module.tags or per-label tags | `list(string)` | <pre>[<br/>  "environment",<br/>  "terraform"<br/>]</pre> | no |
| <a name="input_sanitize_names"></a> [sanitize\_names](#input\_sanitize\_names) | Whether to sanitize composed names (lowercase, replace invalid characters with '-') | `bool` | `true` | no |
| <a name="input_service_accounts"></a> [service\_accounts](#input\_service\_accounts) | Optional map of service account definitions that labels can reference. Keyed by logical name. Each object may include create (bool) and roles (list(string)). | <pre>map(object({<br/>    create = optional(bool, false)<br/>    roles  = optional(list(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to the resources. Set global tag values in the "this" version of the module, and then pass label specific modifications to "module.this.context". | `map(string)` | `{}` | no |
| <a name="input_unit"></a> [unit](#input\_unit) | The unit identifier that the resources are for. Should be a short-hand identifier. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_delimiter"></a> [delimiter](#output\_delimiter) | The delimiter selected. |
| <a name="output_enabled"></a> [enabled](#output\_enabled) | A boolean to enable or disable the module. |
| <a name="output_environment"></a> [environment](#output\_environment) | The environment for the resources (e.g. dev, prod, staging). |
| <a name="output_id"></a> [id](#output\_id) | The ID to use for the resources. |
| <a name="output_labels"></a> [labels](#output\_labels) | A map of objects that will define any desired labels. |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | The appropriate namespace for the resource(s). |
| <a name="output_region"></a> [region](#output\_region) | The GCP region for the resource(s). |
| <a name="output_tags"></a> [tags](#output\_tags) | The tags compiled by the label. |
<!-- END_TF_DOCS -->
