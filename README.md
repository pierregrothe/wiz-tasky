# wiz-tasky Terraform Project

This project provisions infrastructure for the wiz-tasky project using Terraform. Key components include:

- **VPC Module:** Provisions a Virtual Private Cloud (VPC) with public and private subnets, an Internet Gateway, and a NAT Gateway.
- **Remote State:** Managed using Terraform Cloud.
- **Consistent Tagging:** Implements a merged tagging strategy across resources.

## Directory Structure

- **backend.tf:** Remote backend configuration for Terraform Cloud.
- **providers.tf:** AWS provider configuration.
- **variables.tf:** Global variables for project configuration.
- **locals.tf:** Local definitions (merged tags).
- **main.tf:** Root module that instantiates the VPC module.
- **outputs.tf:** Exposes key outputs from the infrastructure.
- **versions.tf:** Global version constraints.
- **modules/vpc/:** Contains the VPC module code.

## Usage

1. **Configure Terraform Cloud:**
   - Update `backend.tf` with the correct workspace name for your environment.

2. **Set Variables:**
   - Adjust values in `variables.tf` as needed.

3. **Deploy Infrastructure:**
   - Run `terraform init` and `terraform apply` to provision the resources.

## Notes

- The `assessment_mode` flag is available to toggle intentional misconfigurations for the Wiz Technical Assessment.
- Consistent tagging is enforced via `locals.tf`.

## License

This project is licensed under the MIT License.
