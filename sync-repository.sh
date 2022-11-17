#!/bin/bash

get_https_clone_url() {
  echo "$1" | python3 -c "import sys, json; print(json.load(sys.stdin)['repositoryMetadata']['cloneUrlHttp'])"
}

if [ $# -lt 1 ] || [ $# -gt 1 ] || [ -z "$1" ]; then
  echo "Invalid arguments"
  echo "Usage: sync-repository.sh <repository-name>"
  exit 1
fi

repository_name="$1"

# Setup AWS CodeCommit Credential Helper
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true

# Verify repository exists, if it does not, create it
output_json="$(aws codecommit get-repository --repository-name "$repository_name")"
if [ $? -ne 0 ]; then
  output_json="$(aws codecommit create-repository --repository-name "$repository_name")"
fi
if [ $? -ne 0 ]; then
  echo "Could not create repository $repository_name"
  exit 1
fi

# Clone the repository
clone_url="$(get_https_clone_url "$output_json")"
git remote add codecommit "$clone_url"
git push codecommit --mirror
