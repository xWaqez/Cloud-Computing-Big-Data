#!/usr/bin/env bash
set -euo pipefail
# Usage: scripts/deploy.sh v1|v2
TAG="${1:-v1}"
cd "$(dirname "$0")/.."

echo "==> (Re)building image with Packer (tag: $TAG)"
cd packer
packer init . >/dev/null || true
packer build -var "app_version=${TAG}" webserver.pkr.hcl

echo "==> Deploying tag $TAG with Terraform"
cd ../terraform
terraform init -input=false || true
terraform apply -auto-approve -var "image_tag=${TAG}"
