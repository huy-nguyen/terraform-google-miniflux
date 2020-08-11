variable "subnet_ip_range" {
  description = <<-EOT
  IP CIDR range for the subnetwork.
  See https://www.terraform.io/docs/providers/google/d/compute_subnetwork.html#ip_cidr_range.
  EOT
  type        = string
}

variable "region" {
  description = "A valid Google Cloud Platform region."
  type        = string
}
variable "zone" {
  description = "A valid Google Cloud Platform zone."
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
    prefix_length = number
  })
}

variable "serverless_vpc_access_connector_name" {
  type = string
  description = "Name for the Serverless VPC Access Connector with which the App Engine will use to connect with the SQL database."
  default = "miniflux-connector"
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
  type = string
}

variable "sql_instance_disk_type" {
  description = "Whether the SQL instance will use HDD or SSD."
  type = string
  default = "PD_SSD"
}

variable "db_name" {
  type = string
  description = "The name of the PostgreSQL database that the Miniflux application will use"
  default = "miniflux-db"
}
variable "db_user_name" {
  type = string
  description = "The username that the Miniflux application will use to access the PostgreSQL database"
  default = "miniflux"
}

variable "db_user_password" {
  description = "The password that the Miniflux application will use to access the PostgreSQL database"
  type = string
}
