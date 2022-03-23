#!/bin/bash
# should be called from ./environments/<env>

environment_folder=$(pwd)
services_file="$environment_folder/services.txt"

if ! [[ -f "$services_file" ]]; then
  echo "Services definition file $services_file does not exist"
  exit 1
fi

pushd "$environment_folder/../../"
root_folder=$(pwd)

while IFS= read -r service || [[ -n "$service" ]]; do
  service_tf="services/$service.tf"
  if ! [[ -f "$service_tf" ]]; then
    echo "Service definition not found at $service_tf"
    exit 1
  fi

  echo "Linking service: $service"
  ln -s "$root_folder/$service_tf" "infrastructure/$service.tf"
done < "$services_file"
