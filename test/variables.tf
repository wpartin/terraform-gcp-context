variable "labels" {
  description = "A map of labels to apply to all resources"
  type        = map(string)
  default = {
    terraform   = "true"
    environment = "test"
  }
}
