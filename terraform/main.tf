# ----------------------------
# Cloud Run Job
# ----------------------------
resource "google_cloud_run_v2_job" "gcp_nuke_job" {
  name     = "gcp-nuke-job"
  location = var.region

  deletion_protection = false

  template {
    template {
      service_account = google_service_account.gcp_nuke.email

      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/gcp-nuke-repo/gcp-nuke-job:latest"

        env {
          name  = "PROJECT_ID"
          value = var.project_id
        }

        resources {
          limits = {
            cpu    = "1"
            memory = "512Mi"
          }
        }
      }

      max_retries = 3
      timeout     = "300s"
    }

    parallelism = 1

    labels = {
      managed_by = "terraform"
    }
  }
}

# ----------------------------
# Cloud Scheduler
# ----------------------------
resource "google_cloud_scheduler_job" "gcp_nuke_schedule" {
  name        = "gcp-nuke-schedule"
  description = "Run gcp-nuke every day at 2am"
  schedule    = "0 2 * * *"
  time_zone   = "Europe/Paris"
  region      = "europe-west1" # Restricted to some regions for Cloud Scheduler

  http_target {
    http_method = "POST"
    uri         = "https://${var.region}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${var.project_id}/jobs/${google_cloud_run_v2_job.gcp_nuke_job.name}:run"

    oauth_token {
      service_account_email = google_service_account.gcp_nuke.email
    }
  }
}
