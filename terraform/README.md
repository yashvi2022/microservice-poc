# Terraform Configuration for AKS

This directory contains Terraform configuration for provisioning Azure Kubernetes Service (AKS) cluster.

## Prerequisites

- Azure CLI installed and authenticated
- Terraform >= 1.0 installed

## Configuration

Update the following placeholders in `variables.tf`:
- `acr_name`: Must be globally unique
- `node_count`: Adjust based on workload requirements
- `node_vm_size`: Choose appropriate VM size
- `kubernetes_version`: Update to desired version

## Usage

```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Apply the configuration
terraform apply

# Get AKS credentials
az aks get-credentials --resource-group <resource-group-name> --name <cluster-name>

# Verify connection
kubectl get nodes
```

## Outputs

- `acr_login_server`: Use this for Docker image registry
- `aks_kube_config`: Kubernetes configuration (sensitive)
- ACR credentials for pushing Docker images
