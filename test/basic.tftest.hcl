




run "validate_tags" {
  command = plan

  assert {
    condition = alltrue([
      contains(keys(module.this.tags), "terraform"),
      module.this.tags["terraform"] == "true",
      contains(keys(module.this.tags), "environment"),
      module.this.tags["environment"] == "test"
    ])
    error_message = "Required tags are missing"
  }
}

run "validate_labels" {
  command = plan

  assert {
    condition = alltrue([
      contains(keys(module.gke_context.resources), "medplum"),
      module.gke_context.resources["medplum"]["id"] == "phi-datastore",
      contains(keys(module.gke_context.resources), "temporal"),
      module.gke_context.resources["temporal"]["id"] == "workflow-engine"
    ])
    error_message = "Required labels are missing"
  }
}
