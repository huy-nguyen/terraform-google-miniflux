# Miniflux for Google Cloud Platform (GCP) App Engine

This Terraform module sets up the infrastructure, such as the VPC network and database, to run [Miniflux](https://miniflux.app/), a free and open-source feed reader, in App Engine on Google Cloud Platform.
Note that this module does not set up App Engine itself, just all the infrastructure that the App Engine will need to function properly.

Before starting, you will have to enable the following Google APIs in your project:
- Compute Engine API (`compute.googleapis.com`).
- Service Networking API (`servicenetworking.googleapis.com`).
- Cloud Resource Manager API (`cloudresourcemanager.googleapis.com`).
- Serverless VPC Access API (`vpcaccess.googleapis.com`).
- SQL Admin API (`sqladmin.googleapis.com`).
- App Engine Admin API (`appengine.googleapis.com`).

You will also have to give the following IAM roles to the service account whose credentials Terraform will use to run:
- Compute Network Admin (`roles/compute.networkAdmin`).
- Service Networking Admin (`roles/servicenetworking.networksAdmin`).
- Serverless VPC Access Admin (`roles/vpcaccess.admin`).
- Cloud SQL Admin (`roles/cloudsql.admin`).

After deploying this module, you'll need to perform the following steps to get a working version of Miniflux:
- Clone the [Miniflux repo](https://github.com/miniflux/miniflux), check out a release tag and `cd` into the directory.
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
    DATABASE_URL: value of the database_url output. Remember to substitute with your password where appropriate.
```
- Run `gcloud app deploy`.
- After the first App Engine version has been created, give the default App Engine service account the Cloud SQL Client role (`roles/cloudsql.client`) so that it can access the database.
This service account's email address has the form `YOUR_PROJECT_ID@appspot.gserviceaccount.com`.

Now you can navigate to your App Engine's URL and log in with the `ADMIN_USERNAME` and `ADMIN_PASSWORD` specified above.
