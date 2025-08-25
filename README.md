# gcp-nuke

A simple script to clean a GCP project

## Local usage

```bash
# install
brew install ekristen/tap/gcp-nuke

# activate APIs for gcp-nuke
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable storage.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable cloudfunctions.googleapis.com
gcloud services enable pubsub.googleapis.com
gcloud services enable iam.googleapis.com
# also needed for CI/CD :
gcloud services enable cloudscheduler.googleapis.com

# check activated APIs
gcloud services list --enabled
```

### Dry-run

```bash
export CURRENT_GCP_PROJECT_ID=<current-gcp-project-id>

export GOOGLE_APPLICATION_CREDENTIALS=creds.json
# or
gcloud config auth

gcp-nuke run --config config.yml --no-prompt --project-id $CURRENT_GCP_PROJECT_ID
```

### Execute

```bash
gcp-nuke run --config config.yml --no-prompt --no-dry-run --project-id $CURRENT_GCP_PROJECT_ID
```

## CI/CD usage

### 1. Create the repo

```bash
gcloud artifacts repositories create gcp-nuke-repo \
  --repository-format=docker \
  --location=europe-west9 \
  --description="Docker Repo for gcp-nuke"
```

### 2. Build & Push the Docker image

```bash
podman build -t europe-west9-docker.pkg.dev/$CURRENT_GCP_PROJECT_ID/gcp-nuke-repo/gcp-nuke-job:latest .

gcloud auth configure-docker europe-west9-docker.pkg.dev
podman push europe-west9-docker.pkg.dev/$CURRENT_GCP_PROJECT_ID/gcp-nuke-repo/gcp-nuke-job:latest
```

### 3. Terraform deployment

```bash
unset GOOGLE_APPLICATION_CREDENTIALS
gcloud auth application-default login

cd terraform
terraform init
terraform apply -var="project_id=$CURRENT_GCP_PROJECT_ID" -var="region=europe-west9"
```
