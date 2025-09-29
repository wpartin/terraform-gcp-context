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

output "labels" {
  description = "A map of objects that will define any desired labels."
  value       = local.finalized_labels
}

output "namespace" {
  description = "The appropriate namespace for the resource(s)."
  value       = var.namespace
}

output "region" {
  description = "The GCP region for the resource(s)."
  value       = var.region
}

output "tags" {
  description = "The tags compiled by the label."
  value       = var.tags
}
