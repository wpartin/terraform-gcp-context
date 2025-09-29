module "this" {
  source = "../"

  environment = "test"
  namespace   = "gke"
  region      = "us-central1"

  labels = {
    terraform   = "true"
    environment = "test"
  }
}

module "bucket_context" {
  source = "../"

  context     = module.this
  namespace   = "gcs"
  environment = module.this.environment

  labels = {
    terraform      = "true"
    environment    = "test"
    "self-service" = false
  }
}

module "gke_context" {
  source = "../"

  context     = module.this
  environment = module.this.environment

  resources = {
    medplum = {
      id   = "phi-datastore"
      labels = {
        team = "all-stars"
      }
    }
    temporal = {
      id   = "workflow-engine"
      labels = {
        team = "boogy-bots"
      }
    }
  }
}

resource "google_storage_bucket" "bucket" {
  location = module.bucket_context.region
  name     = "my-bucket"

  labels = module.bucket_context.labels
}

resource "google_container_cluster" "gke" {
  for_each = module.gke_context.labels

  location = module.gke_context.region
  name     = "my-${each.key}-gke-cluster"

  initial_node_count = 1

  resource_labels = each.value.labels
}
