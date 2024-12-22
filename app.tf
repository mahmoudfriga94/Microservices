data "google_client_config" "client1" {}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.mycluster.endpoint}"
  token                  = data.google_client_config.client1.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.mycluster.master_auth[0].cluster_ca_certificate)

  ignore_annotations = [
    "^autopilot\\.gke\\.io\\/.*",
    "^cloud\\.google\\.com\\/.*"
  ]
}

