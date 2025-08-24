#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

echo "==> Building immutable image v1 with Packer ..."
cd packer
packer init . >/dev/null
packer build -var 'app_version=v1' webserver.pkr.hcl

echo "==> Deploying with Terraform (image tag v1) ..."
cd ../terraform
terraform init -input=false
terraform apply -auto-approve -var 'image_tag=v1'
