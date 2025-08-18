# gcp-nuke

To clean a GCP env

## Install / config

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

# check activated APIs
gcloud services list --enabled
```

## Launch a Dry-Run

```bash
export GOOGLE_APPLICATION_CREDENTIALS=creds.json
gcp-nuke run --config config.yml --no-prompt --project-id <my-project>
```

## Launch it

```bash
gcp-nuke run --config config.yml --no-prompt  --no-dry-run --project-id <my-project>
```
