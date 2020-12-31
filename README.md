# Miniflux for Google Cloud Platform (GCP) App Engine

This Terraform module sets up the infrastructure (such as the VPC network and database) to run [Miniflux](https://miniflux.app/), a free and open-source feed reader, in App Engine on Google Cloud Platform (GCP) in a secure manner.
Security means that this setup uses GCP's [private services access](https://cloud.google.com/sql/docs/postgres/private-ip) to restrict access so that the PostgreSQL database is accessible only through the browser-based user interface served up by App Engine and not exposed to the public internet.
Below is a diagram of how the infrastructure is set up based on this [sample Terraform config](https://github.com/huy-nguyen/terraform-google-miniflux/blob/master/examples/minimal.tf):

![Cloud infrastructure diagram](diagram.svg)

Note that this Terraform module does not set up App Engine itself, just all the infrastructure that App Engine will need to function properly.
However, I've included instructions on how to use the outputs from the module to create the configuration for App Engine.

# Prerequisites

Before starting, you will have to enable the following Google APIs in your project:

- Compute Engine API (`compute.googleapis.com`).
- Service Networking API (`servicenetworking.googleapis.com`).
- Cloud Resource Manager API (`cloudresourcemanager.googleapis.com`).
- Serverless VPC Access API (`vpcaccess.googleapis.com`).
- Cloud SQL Admin API (`sqladmin.googleapis.com`).
- App Engine Admin API (`appengine.googleapis.com`).

Create a service account for Terraform and give the following IAM roles to that service account:

- Compute Network Admin (`roles/compute.networkAdmin`).
- Service Networking Admin (`roles/servicenetworking.networksAdmin`).
- Serverless VPC Access Admin (`roles/vpcaccess.admin`).
- Cloud SQL Admin (`roles/cloudsql.admin`).

# Infrastructure provisioning

You can use the provided [sample Terraform config](https://github.com/huy-nguyen/terraform-google-miniflux/blob/master/examples/minimal.tf) as a starting point.

Run the following commands:

- `terraform init`
- `terraform plan`
- `terraform apply`
- `terraform output` to get the output values that will be necessary in deploying App Engine next.

# Deployment to App Engine

After deploying this module, you'll need to perform the following steps to get a working version of Miniflux:

- Clone the [Miniflux repo](https://github.com/miniflux/v2), `cd` into the directory and check out a [release tag](https://github.com/miniflux/v2/tags).
- Use the outputs exposed by this Terraform module to create an `app.yaml` file with the following content:

```yaml
runtime: go111
vpc_access_connector:
  name: value of the vpc_access_connector_id output
env_variables:
  CLOUDSQL_CONNECTION_NAME: value of the sql_connection_name output
  CLOUDSQL_USER: value of the sql_instance_user output
  CLOUDSQL_PASSWORD: value of the db_user_password you pass into the module

  CREATE_ADMIN: 1
  ADMIN_USERNAME: pick any name you want for the initial login
  ADMIN_PASSWORD: pick any password you want for the initial login
  RUN_MIGRATIONS: 1
  DATABASE_URL: value of the database_url output. Remember to substitute the placeholder password with the real password i.e. the Terraform input variable "db_user_password"
```

- We'll use the `gcloud` CLI to deploy to App Engine.
  Ensure you're authenticated with the `gcloud` CLI.
  If not, run `gcloud auth login`.
- Ensure you've picked the correct project.
  Run `gcloud config get-value project` to check.
  If the project is not correct, run `gcloud config set project [PROJECT-NAME]` to set it.
- Run `gcloud app deploy`.
  You will be prompted to choose a region.
  Pick the same region as the `region` input variable of this Terraform module.
- After the first App Engine version has been created, you _might_ have to give the default App Engine service account the Cloud SQL Client role (`roles/cloudsql.client`) so that it can access the database.
  This service account's email address has the form `YOUR_PROJECT_ID@appspot.gserviceaccount.com`.

Now you can navigate to your App Engine's URL and log in with the `ADMIN_USERNAME` and `ADMIN_PASSWORD` specified above.
