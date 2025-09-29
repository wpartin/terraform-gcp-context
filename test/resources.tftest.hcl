run "validate_labels" {
  command = plan

  assert {
    condition = alltrue([
      contains(keys(module.gke_context.resources), "medplum"),
      module.gke_context.resources["medplum"]["id"] == "phi-datastore",
      contains(keys(module.gke_context.resources), "temporal"),
      module.gke_context.resources["temporal"]["id"] == "workflow-engine"
    ])
    error_message = "Required resources are missing"
  }
}
