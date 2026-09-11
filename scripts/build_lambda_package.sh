#!/usr/bin/env bash
set -euo pipefail

project_dir="$1"
build_dir="$project_dir/.build/lambda"

rm -rf "$build_dir"
mkdir -p "$build_dir"

python3 -m pip install --disable-pip-version-check --no-cache-dir \
  --target "$build_dir" \
  -r "$project_dir/src/lambda/requirements.txt"

cp "$project_dir/src/lambda/handler.py" "$build_dir/handler.py"
