terraform {
  required_version = ">= 1.6.0, < 2.0.0"
}

locals {
  regions = {
    "us-central1" = "usc1"
    "us-east1"    = "use1"
    "us-east4"    = "use4"
    "us-west1"    = "usw1"
    "us-west2"    = "usw2"
  }

  initialized_resources = {
    for resource, configuration in var.resources : resource => {
      enabled         = coalesce(configuration.enabled, var.enabled)
      environment     = var.environment
      id              = coalesce(configuration.id, var.id)
      id_length_limit = coalesce(configuration.id_length_limit, var.id_length_limit)
      label_order     = coalesce(configuration.label_order, var.label_order)
      namespace       = try(configuration.namespace, var.namespace, "")
      root_context    = try(configuration.context, var.context, {})
      region          = coalesce(configuration.region, var.region)
      region_short    = lookup(local.regions, coalesce(configuration.region, var.region), coalesce(configuration.region, var.region))
      unit            = try(configuration.unit, var.unit, "")
      tags            = { for k, v in merge(var.labels, try(configuration.tags, {})) : k => tostring(v) }
    }
  }

  id_parts_map = {
    for label, configuration in local.initialized_resources : label => [for _, lab in configuration.label_order : tostring(lab == "region" ? lookup(configuration, "region_short") : lookup(configuration, lab)) if(lab == "region" ? lookup(configuration, "region_short") : lookup(configuration, lab)) != null && (lab == "region" ? lookup(configuration, "region_short") : lookup(configuration, lab)) != ""]
  }

  # sanitization helper: conservative replacements (no regex) to stay compatible
  sanitized = { for k, v in local.id_parts_map : k => [for item in v : lower(replace(replace(replace(replace(replace(replace(tostring(item), " ", "-"), "_", "-"), ".", "-"), ":", "-"), "/", "-"), "@", "-"))] }

  finalized_resources = {
    for label, configuration in local.initialized_resources : label => merge(configuration, {
      id_full  = join(var.delimiter, var.sanitize_names ? local.sanitized[label] : local.id_parts_map[label])
      id_short = join(var.delimiter, slice(var.sanitize_names ? local.sanitized[label] : local.id_parts_map[label], 0, min(length(var.sanitize_names ? local.sanitized[label] : local.id_parts_map[label]), configuration.id_length_limit)))
    })
  }

  # service account scaffolding: expose desired SA names and requested roles (no creation here)
  service_account_requests = { for name, sa in var.service_accounts : name => sa }

  # validate required tags exist (this is best-effort at plan-time)
  missing_required_tags = [for t in var.required_labels : t if !contains(keys(var.labels), t)]
}
