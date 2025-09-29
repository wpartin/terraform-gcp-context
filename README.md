# Usage
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

  tags = {
    terraform      = "true"
    environment    = "test"
    "self-service" = false
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
