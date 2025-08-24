#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

echo "==> Building immutable image v2 with Packer ..."
cd packer
packer build -var 'app_version=v2' webserver.pkr.hcl

echo "==> Immutable update: switching Terraform to image tag v2 ..."
cd ../terraform
terraform apply -auto-approve -var 'image_tag=v2'
