# Terragrunt and Terraform Multi-Environment Management
This repository demonstrates how the Terragrunt plugin with the Terraform command-line tool can be utilized to manage multiple environments for different needs.

## Prerequisites

Before running any script, ensure that a specific variable is present in your system environment list: TF_VAR_ECHO_TEXT. This variable is required as sensitive data for the task. Define and export it on your system as follows:

**POSIX:**
```sh
export TF_VAR_ECHO_TEXT="my sensitive data"
```

**Windows:**
```sh
$env:TF_VAR_ECHO_TEXT="my sensitive data"
```

This variable will be passed to the Docker container to be echoed later.

## Deployment

A Python script is provided to handle cross-platform deployment (assuming Python is installed on your system). You can run it from the root of the project with:

```python
python3 ./scripts/deploy.py
```

This script manages the entire deployment process.

Alternatively, there are two scripts that can be run on macOS/Linux operating systems (deploy.sh and setup.sh). If your system does not have Terraform, Terragrunt, and AWS CLI installed, you can run:

```sh
./setup.sh && ./deploy.sh
```

If these tools are already installed on your system, you can skip the setup.sh script.

The deployment script reads the TF_VAR_ECHO_TEXT variable from your system, which will be included in the Docker setup as sensitive data. This ensures the variable value is not stored in the repository.

# Modules

## LightSail Module

The LightSail module provisions an AWS LightSail instance, uses a specific Docker container from HashiCorp as an echo server (https://github.com/hashicorp/http-echo), and opens ports 22, 80, 443, 8080, and 5678 (for custom Docker) for communication.

## Route53 Module

The Route53 module is designed to use a load balancer and enforce HTTPS connections. This module assumes the FQDN (domain name) is already configured in LightSail, the certificate has been handled for HTTPS and there is a load balancer which uses the certificate. To use this, modify the folder structure and create another terragrunt.hcl file for each environment component in a separate folder. The content of the file should point to the main.tf file, similar to the example below:

```bash
Root
├── README.MD
├── scripts
│   ├── deploy.py
│   ├── deploy.sh
│   └── setup.sh
└── terraform
    ├── environments
    │   ├── dev
    │   │   ├── lightsail
    │   │   │   └──terragrunt.hcl
    │   │   └── route53
    │   │       └──terragrunt.hcl
    │   ├── prod
    │   │   ├── lightsail
    │   │   │   └──terragrunt.hcl
    │   │   └── route53
    │   │       └──terragrunt.hcl
    ├── modules
    │   ├── lightsail
    │   │   ├── main.tf
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   ├── route53
    │   │   ├── main.tf
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   └── route53-https
    │       ├── main.tf
    │       ├── outputs.tf
    │       └── variables.tf
    └── lightsail
    │   └── terragrunt.hcl
    └── route53
        └── terragrunt.hcl    
```

```sh
include {
  path = find_in_parent_folders()
}

inputs = {
  name = "route53"
}
```

Another terragrunt.hcl file is needed for calling Route53 module in the root folder (additional one ), as Terragrunt does not support multiple Terraform blocks in the same HCL file. This step has been skipped for brevity.

If the above module setup is not feasible, an alternative (work-in-progress) module can help create all the intermediate components for HTTPS. However, it is currently in draft status and not tested (route53-https).


# Post-Deployment

Once the deployment process is successfully completed, you will see the IP addresses of the development and production instances. To verify, open a browser and type <ip_address>:5678. You should see the TF_VAR_ECHO_TEXT variable displayed in the browser.

(I did not test the windows version since I don't have a windows machine, the linux and macos instuctions should work as explained above)