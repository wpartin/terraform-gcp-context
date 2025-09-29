module "this" {
  source = "../"

  environment = "test"
  namespace   = "gke"
  region      = "us-central1"

  tags = {
    terraform   = "true"
    environment = "test"
  }
}

module "bucket_context" {
  source = "../"

  context     = module.this
  namespace   = "gcs"
  environment = module.this.environment

  tags = {
    terraform      = "true"
    environment    = "test"
    "self-service" = false
  }
}

module "gke_context" {
  source = "../"

  context     = module.this
  environment = module.this.environment

  labels = {
    medplum = {
      id   = "phi-datastore"
      tags = {
        team = "all-stars"
      }
    }
    temporal = {
      id   = "workflow-engine"
      tags = {
        team = "boogy-bots"
      }
    }
  }
}

resource "google_storage_bucket" "bucket" {
  location = module.bucket_context.region
  name     = "my-bucket"

  labels = module.bucket_context.tags
}

resource "google_container_cluster" "gke" {
  for_each = module.gke_context.labels

  location = module.gke_context.region
  name     = "my-${each.key}-gke-cluster"

  initial_node_count = 1

  resource_labels = each.value.tags
}
