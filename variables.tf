variable "project_id" {
  description = "The Google Cloud project ID in which resources will be created."
  type        = string

}
variable "region" {
  description = "The Google Cloud Platform region for App Engine."
  type        = string
}
variable "zone" {
  description = <<-EOT
  The Google Cloud Platform zone for the PostgreSQL database.
  This zone should be within the region selected for the "region" input variable.
  EOT
  type        = string
}

variable "private_services_access_ip_range" {

  description = <<-EOT
  An internal IP CIDR range allocated to Google Cloud for Private Services Access.
  It should not overlap with the IP range of any of your existing subnetworks.
  See https://cloud.google.com/vpc/docs/private-access-options#service-networking.
  EOT

  type = object({
    starting_address = string,
    prefix_length    = number
  })
}

variable "serverless_vpc_access_connector_name" {
  type        = string
  description = "Name for the Serverless VPC Access Connector with which the App Engine will use to connect with the SQL database."
  default     = "miniflux-connector"
}

variable "serverless_vpc_access_connector_ip_range" {
  description = <<-EOT
  A /28 internal IP CIDR range for the Serverless VPC Access Connector.
  It should not overlap with the IP range of any of your existing subnetworks.
  See https://www.terraform.io/docs/providers/google/r/vpc_access_connector.html#ip_cidr_range.
  EOT

  type = string
}

variable "sql_instance_machine_type" {
  description = <<-EOT
  The machine type for your SQL instance.
  See https://cloud.google.com/sql/docs/postgres/create-instance#machine-types.
  EOT
  type        = string
}

variable "sql_instance_disk_type" {
  description = "Whether the SQL instance will use HDD or SSD."
  type        = string
  default     = "PD_SSD"
}

variable "db_name" {
  type        = string
  description = "The name of the PostgreSQL database that the Miniflux application will use"
  default     = "miniflux-db"
}
variable "db_user_name" {
  type        = string
  description = "The username that the Miniflux application will use to access the PostgreSQL database"
  default     = "miniflux"
}

variable "db_user_password" {
  description = <<-EOT
  The password that the Miniflux application will use to access the PostgreSQL database.
  It's highly recommended to pick a password without spaces because it will be used as part of a URL.
  EOT
  type        = string
  sensitive   = true
}
