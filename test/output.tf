output "this" {
  description = "The root module context."
  value       = module.this
}

output "bucket_context" {
  description = "The context label for buckets."
  value       = module.bucket_context
}

output "gke_context" {
  description = "The context label for GKE clusters."
  value       = module.gke_context
}
