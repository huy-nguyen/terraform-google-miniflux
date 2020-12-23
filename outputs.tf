locals {
  user_name = google_sql_user.db_user.name
  sql_ip    = google_sql_database_instance.sql_instance.private_ip_address
  db_name   = google_sql_database.db.name
}
output "sql_connection_name" {
  value       = google_sql_database_instance.sql_instance.connection_name
  description = "The value of the `env_variables.CLOUDSQL_CONNECTION_NAME` field in `app.yaml`."
}

output "sql_instance_user" {
  value       = local.user_name
  description = "The value of the `env_variables.CLOUDSQL_USER` field in `app.yaml`."
}

output "vpc_access_connector_id" {
  value       = google_vpc_access_connector.vpc_access_connector.id
  description = "The value of the `vpc_access_connector.name` field in `app.yaml`."
}

output "sql_instance_ip" {
  value       = local.sql_ip
  description = "The private IP of the Cloud SQL instance."
}

output "db_name" {
  value       = local.db_name
  description = "The name of the SQL database."
}

output "database_url" {
  value       = "postgres://${local.user_name}:<YOUR_PASSWORD>@${local.sql_ip}:5432/${local.db_name}?sslmode=disable"
  description = "The value of the `env_variables.DATABASE_URL` field in `app.yaml`. Remember to substitute with your password where appropriate."
}
