# GitHub Actions Setup Guide

## Required GitHub Secrets

Configure the following secrets in your GitHub repository (Settings > Secrets and variables > Actions):

### 1. AZURE_CREDENTIALS
Service principal credentials for Azure authentication.

Create a service principal:
```bash
az ad sp create-for-rbac \
  --name "github-actions-polyglot" \
  --role contributor \
  --scopes /subscriptions/{subscription-id}/resourceGroups/{resource-group} \
  --sdk-auth
```

Copy the entire JSON output and paste it as the `AZURE_CREDENTIALS` secret.

### 2. ACR_NAME
Azure Container Registry name (without .azurecr.io)

Example: `polyglotmicroservicesacr`

### 3. AKS_CLUSTER_NAME
Name of your AKS cluster

Example: `polyglot-aks-cluster`

### 4. AKS_RESOURCE_GROUP
Name of the resource group containing your AKS cluster

Example: `polyglot-microservices-rg`

## Workflow Triggers

The workflow runs on:
- Push to `main` or `master` branch
- Manual trigger via GitHub Actions UI

## Workflow Steps

1. **Build and Push**: Builds Docker images for all services and pushes to ACR
2. **Deploy**: Deploys all resources to AKS in the correct order:
   - Namespaces
   - Secrets and ConfigMaps
   - StatefulSets (databases, Kafka)
   - Application Deployments
   - Ingress Resources

## DNS Configuration

After deployment, configure DNS records for:
- `mandlebulbtech.in` → Ingress LoadBalancer IP
- `www.mandlebulbtech.in` → Ingress LoadBalancer IP
- `api.mandlebulbtech.in` → Ingress LoadBalancer IP
- `mongo-express.mandlebulbtech.in` → Ingress LoadBalancer IP
- `pgadmin.mandlebulbtech.in` → Ingress LoadBalancer IP
- `kafka-ui.mandlebulbtech.in` → Ingress LoadBalancer IP

Get the LoadBalancer IP:
```bash
kubectl get svc -n ingress-nginx
```
