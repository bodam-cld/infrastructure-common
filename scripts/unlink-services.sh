#!/bin/bash
# should be called from ./environments/<env>

environment_folder=$(pwd)
services_file="$environment_folder/services.txt"

if ! [[ -f "$services_file" ]]; then
  echo "Services definition file $services_file does not exist"
  exit 1
fi

pushd "$environment_folder/../../"

while IFS= read -r service || [[ -n "$service" ]]; do
  echo "Unlinking service: $service"
  rm -f "infrastructure/$service.tf"
done < "$services_file"
