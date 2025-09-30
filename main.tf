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
    for name, configuration in var.resources : name => {
      enabled           = coalesce(configuration.enabled, var.enabled)
      environment       = var.environment
      id                = coalesce(configuration.id, var.id)
      id_length_limit   = coalesce(configuration.id_length_limit, var.id_length_limit)
      id_order          = coalesce(configuration.id_order, var.id_order)
      labels            = { for k, v in merge(try(var.context.labels, {}), var.labels, try(configuration.labels, {})) : k => tostring(v) }
      namespace         = try(configuration.namespace, var.namespace, "")
      naming_max_length = try(configuration.naming_max_length, null)
      region            = coalesce(configuration.region, var.region)
      region_short      = lookup(local.regions, coalesce(configuration.region, var.region), coalesce(configuration.region, var.region))
      unit              = try(configuration.unit, var.unit, "")
    }
  }

  service_max_lengths = {
    default = 63
    bucket  = 63
    gke     = 40
    project = 30
    pubsub  = 255
  }

  id_parts_map = {
    for name, configuration in local.initialized_resources : name => [for _, n in configuration.id_order : tostring(n == "region" ? lookup(configuration, "region_short") : lookup(configuration, n)) if(n == "region" ? lookup(configuration, "region_short") : lookup(configuration, n)) != null && (n == "region" ? lookup(configuration, "region_short") : lookup(configuration, n)) != ""]
  }

  # sanitization helper: conservative replacements (no regex) to stay compatible
  sanitized = { for k, v in local.id_parts_map : k => [for item in v : lower(replace(replace(replace(replace(replace(replace(tostring(item), " ", "-"), "_", "-"), ".", "-"), ":", "-"), "/", "-"), "@", "-"))] }

  finalized_resources = {
    for name, configuration in local.initialized_resources : name => merge(configuration, {
      id_full = join(var.delimiter, var.sanitize_names ? local.sanitized[name] : local.id_parts_map[name])
      id_short = join(var.delimiter, [ # first two parts are full length, the rest are truncated to 3 characters
        for idx, part in(var.sanitize_names ? local.sanitized[name] : local.id_parts_map[name]) :
        idx < 2 ? tostring(part) : substr(tostring(part), 0, min(length(tostring(part)), 3))
      ])
      root_context = var.context
    })
  }

  missing_required_labels = distinct(flatten([
    for name, configuration in local.finalized_resources : [
      for required in var.required_labels : required if !contains(keys(configuration.labels), required)
    ]
  ]))
}
