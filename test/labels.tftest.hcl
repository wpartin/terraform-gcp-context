run "validate_labels" {
  command = plan

  assert {
    condition = alltrue([
      contains(keys(module.this.labels), "terraform"),
      module.this.labels["terraform"] == "true",
      contains(keys(module.this.labels), "environment"),
      module.this.labels["environment"] == "test"
    ])
    error_message = "Required labels are missing"
  }
}

run "missing_required_labels" {
  command = plan

  variables {
    labels = {}
  }

  assert {
    condition     = module.gke_context.missing_required_labels
    error_message = "Expected missing required labels to be reported"
  }
}
