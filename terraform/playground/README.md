# Temporary workstation in the cloud

## Usage

- `make apply` will create a workstation and will return its IP address
- `make destroy` will clean everything up

## Features

- Cloud instance will be recreated with the same IP address after any
  modifications to cloud-init config (`workstation.yml`)
- Another instance may be created in a separate Terraform workspace by running
  `make apply HOST=anothername`
