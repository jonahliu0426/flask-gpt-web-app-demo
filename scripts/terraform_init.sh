#!/bin/bash

# Check if .env file exists
if [ ! -f ".tf.env" ]; then
    echo ".tf.env file not found!"
    exit 1
fi

# Load environment variables and export them for Terraform
set -a  # automatically export all variables
source .tf.env
set +a

# Prefix environment variables with TF_VAR_
for var in $(cat .tf.env | grep -v '^#' | grep -v '^$' | cut -d= -f1); do
    value=$(printenv $var)
    export TF_VAR_$var="$value"
done

# Execute Terraform commands
echo "Running Terraform -chdir=terraform/ $1..."
terraform -chdir=terraform/ "$@"
