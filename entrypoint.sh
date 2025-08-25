#!/bin/bash
set -e

echo "Setting project..."
gcloud config set project ${PROJECT_ID}

echo "Running gcp-nuke..."
gcp-nuke run --config config.yml --no-prompt --no-dry-run --project-id ${PROJECT_ID}

echo "gcp-nuke completed."
