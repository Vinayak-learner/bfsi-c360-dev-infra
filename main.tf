data "google_client_config" "current" {}
output "who_am_i" {
  value = data.google_client_config.current.access_token != ""
}
data "google_client_config" "current1" {}
 
output "debug_google_access" {

  value = {

    project = data.google_client_config.current1.project

    region  = data.google_client_config.current1.region

  }

}
 
data "google_project" "current2" {

  project_id = var.project_id

}
 
output "debug_project_number" {

  value = data.google_project.current2.number

}
 

resource "google_storage_bucket" "code_bucket" {
  name     = "bfsi-c360-dev-code_temp"
  location = "US-CENTRAL1"

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 180
    }
  }
}

#==================dm-data-migration-prod=====
resource "google_storage_bucket" "dm_data_migration" {
  name     = "dm-data-migration-dev"
  location = "US-CENTRAL1"

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 180
    }
  }
}

# 2️⃣ Create folders (by creating empty objects ending with '/')
locals {
  folders = [
    # Full load
    "full_load/customer_master/",
    "full_load/product_master/",
    "full_load/loan_master/",
    "full_load/transaction_fact/",

    # Delta load
    "delta_load/customer_master/day_01/",
    "delta_load/customer_master/day_02/",
    "delta_load/customer_master/day_03/",
    "delta_load/customer_master/day_04/",
    "delta_load/customer_master/day_05/",
    "delta_load/customer_master/day_06/",
    "delta_load/customer_master/day_07/",
    "delta_load/customer_master/day_08/",
    "delta_load/customer_master/day_09/",
    "delta_load/customer_master/day_10/",

    "delta_load/product_master/day_01/",
    "delta_load/product_master/day_02/",
    "delta_load/product_master/day_03/",
    "delta_load/product_master/day_04/",
    "delta_load/product_master/day_05/",
    "delta_load/product_master/day_06/",
    "delta_load/product_master/day_07/",
    "delta_load/product_master/day_08/",
    "delta_load/product_master/day_09/",
    "delta_load/product_master/day_10/",

    "delta_load/loan_master/day_01/",
    "delta_load/loan_master/day_02/",
    "delta_load/loan_master/day_03/",
    "delta_load/loan_master/day_04/",
    "delta_load/loan_master/day_05/",
    "delta_load/loan_master/day_06/",
    "delta_load/loan_master/day_07/",
    "delta_load/loan_master/day_08/",
    "delta_load/loan_master/day_09/",
    "delta_load/loan_master/day_10/",

    "delta_load/transaction_fact/day_01/",
    "delta_load/transaction_fact/day_02/",
    "delta_load/transaction_fact/day_03/",
    "delta_load/transaction_fact/day_04/",
    "delta_load/transaction_fact/day_05/",
    "delta_load/transaction_fact/day_06/",
    "delta_load/transaction_fact/day_07/",
    "delta_load/transaction_fact/day_08/",
    "delta_load/transaction_fact/day_09/",
    "delta_load/transaction_fact/day_10/",



    # Archive
    "archive/full_load/",
    "archive/delta_load/"
  ]
}

# 3️⃣ Create empty objects for folders
resource "google_storage_bucket_object" "folders" {
  for_each = toset(local.folders)
  name     = each.key
  bucket   = google_storage_bucket.dm_data_migration.name
  content  = "  "
}
