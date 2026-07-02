#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

rm -rf vendor/scalar
mkdir -p vendor
cp -r node_modules/@scalar/api-reference/dist/browser vendor/scalar

echo "Scalar vendorado em vendor/scalar ($(du -sh vendor/scalar | cut -f1))"
