#! /usr/bin/env bash
set -euo pipefail

cd "${0%/*}"
echo "Running rubocop..."
bundle exec rubocop
