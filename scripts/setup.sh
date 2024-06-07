#!/bin/bash

# Script to install dependencies for AWS CLI and Terraform

curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /

curl -O https://releases.hashicorp.com/terraform/0.14.6/terraform_0.14.6_darwin_amd64.zip
unzip terraform_0.14.6_darwin_amd64.zip
sudo mv terraform /usr/local/bin/

brew install terragrunt
