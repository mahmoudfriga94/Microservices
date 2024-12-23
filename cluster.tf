resource "google_compute_network" "myvpc" {
  name = "vcp1"

  auto_create_subnetworks  = false
  enable_ula_internal_ipv6 = true
}

resource "google_compute_subnetwork" "mysubnet" {
  name = "subnet1"

  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"

  stack_type       = "IPV4_IPV6"
  ipv6_access_type = "EXTERNAL" 

  network = google_compute_network.myvpc.id
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "192.168.0.0/24"
  }

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = "192.168.1.0/24"
  }
}

resource "google_container_cluster" "mycluster" {
  name = "cluster1"

  location                 = "us-central1"
  enable_autopilot         = true
  enable_l4_ilb_subsetting = true

  network    = google_compute_network.myvpc.id
  subnetwork = google_compute_subnetwork.mysubnet.id

  ip_allocation_policy {
    stack_type                    = "IPV4_IPV6"
    services_secondary_range_name = google_compute_subnetwork.mysubnet.secondary_ip_range[0].range_name
    cluster_secondary_range_name  = google_compute_subnetwork.mysubnet.secondary_ip_range[1].range_name
  }

  deletion_protection = false
}