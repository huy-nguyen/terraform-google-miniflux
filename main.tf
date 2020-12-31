locals {
  network_name = "miniflux-network"
}
resource "google_compute_network" "network" {
  name                    = local.network_name
  auto_create_subnetworks = "false"
}

resource "google_compute_global_address" "private_services_access_reserved_ip_range" {
  name          = join("-", ["google-managed-services", local.network_name])
  address       = var.private_services_access_ip_range.starting_address
  prefix_length = var.private_services_access_ip_range.prefix_length
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  network       = google_compute_network.network.self_link
}

resource "google_service_networking_connection" "private_services_access_peering_connection" {
  network = google_compute_network.network.self_link
  service = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [
    google_compute_global_address.private_services_access_reserved_ip_range.name
  ]
}

resource "random_id" "sql_instance_name_suffix" {
  byte_length = 8
}

resource "google_sql_database_instance" "sql_instance" {

  name                = "miniflux-sql-instance-${random_id.sql_instance_name_suffix.hex}"
  region              = var.region
  database_version    = "POSTGRES_12"
  deletion_protection = "false"

  depends_on = [
    google_service_networking_connection.private_services_access_peering_connection
  ]

  settings {
    tier      = var.sql_instance_machine_type
    disk_type = var.sql_instance_disk_type
    location_preference {
      zone = var.zone
    }
    ip_configuration {
      ipv4_enabled    = "false"
      private_network = google_compute_network.network.id
    }
  }
}

resource "google_sql_database" "db" {
  name     = var.db_name
  instance = google_sql_database_instance.sql_instance.name
}

resource "google_sql_user" "db_user" {
  name     = var.db_user_name
  instance = google_sql_database_instance.sql_instance.id
  password = var.db_user_password
}

resource "google_vpc_access_connector" "vpc_access_connector" {
  name          = var.serverless_vpc_access_connector_name
  region        = var.region
  ip_cidr_range = var.serverless_vpc_access_connector_ip_range
  network       = google_compute_network.network.name
}
