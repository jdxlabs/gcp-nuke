resource "google_service_account" "gcp_nuke" {
  account_id   = "sa-gcp-nuke"
  display_name = "Service Account for gcp-nuke"
}

resource "google_project_iam_member" "gcp_nuke_owner" {
  project = var.project_id
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.gcp_nuke.email}"
}
