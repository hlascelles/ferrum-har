#! /usr/bin/env bash
set -euo pipefail

cd "${0%/*}"
echo "Running specs..."
bundle exec rake spec
echo "Running acceptance..."
cd spec/acceptance && bundle exec ruby test.rb
