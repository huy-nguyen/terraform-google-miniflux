provider "google" {
  credentials = file("path_to_file.json")
  project     = "my-project-id"
}

module "miniflux" {
  source  = "huy-nguyen/miniflux/google"
  version = "4.0.0"

  region = "us-east1"
  zone   = "us-east1-d"
  private_services_access_ip_range = {
    starting_address = "192.168.16.0"
    prefix_length    = 20
  }

  serverless_vpc_access_connector_ip_range = "10.8.0.16/28"
  sql_instance_machine_type                = "db-f1-micro"
  db_user_password                         = "pick-a-strong-password"
}
