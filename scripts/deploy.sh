#!/bin/bash

# Make you have terragrunt installed and configured

cd terraform/environments/dev
terragrunt apply --auto-approve

cd ../prod
terragrunt apply --auto-approve
