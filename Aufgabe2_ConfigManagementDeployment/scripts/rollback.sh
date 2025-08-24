#!/usr/bin/env bash
set -euo pipefail
# Usage: scripts/rollback.sh v1
TARGET="${1:-v1}"
cd "$(dirname "$0")/../terraform"
echo "==> Rollback to ${TARGET}"
terraform apply -auto-approve -var "image_tag=${TARGET}"
