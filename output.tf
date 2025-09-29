output "delimiter" {
  description = "The delimiter selected."
  value       = var.delimiter
}

output "enabled" {
  description = "A boolean to enable or disable the module."
  value       = var.enabled
}

output "environment" {
  description = "The environment for the resources (e.g. dev, prod, staging)."
  value       = var.environment
}

output "id" {
  description = "The ID to use for the resources."
  value       = var.id
}

output "ids_full" {
  description = "Map of resource -> id_full values"
  value       = { for name, configuration in local.finalized_resources : name => configuration.id_full }
}

output "ids_short" {
  description = "Map of resource -> id_short values"
  value       = { for name, configuration in local.finalized_resources : name => configuration.id_short }
}

output "labels" {
  description = "The labels compiled by the module."
  value       = var.labels
}

output "missing_required_labels" {
  description = "A list of any required labels that are missing from the compiled labels."
  value       = length(local.missing_required_labels) > 0
}

output "namespace" {
  description = "The appropriate namespace for the resource(s)."
  value       = var.namespace
}

output "region" {
  description = "The GCP region for the resource(s)."
  value       = var.region
}

output "resources" {
  description = "A map of objects that will define any desired resources."
  value       = local.finalized_resources
}

output "resource_labels" {
  description = "A map of resource -> labels maps that includes all labels applied to each resource."
  value       = { for name, configuration in local.finalized_resources : name => configuration.labels }
}
