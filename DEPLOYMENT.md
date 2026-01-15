# Deployment Guide

## Prerequisites

- Azure CLI installed and authenticated
- Terraform >= 1.0
- kubectl installed
- GitHub repository with secrets configured

## Step 1: Provision Infrastructure with Terraform

```bash
cd terraform

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration
terraform apply

# Get outputs
terraform output acr_login_server
terraform output acr_admin_username
terraform output -raw acr_admin_password
```

## Step 2: Configure AKS Access

```bash
# Get AKS credentials
az aks get-credentials \
  --resource-group <resource-group-name> \
  --name <cluster-name>

# Verify connection
kubectl get nodes
```

## Step 3: Configure GitHub Secrets

See `.github/workflows/README.md` for detailed instructions on setting up GitHub secrets.

Required secrets:
- `AZURE_CREDENTIALS`
- `ACR_NAME`
- `AKS_CLUSTER_NAME`
- `AKS_RESOURCE_GROUP`

## Step 4: Deploy via GitHub Actions

1. Push code to `main` or `master` branch, OR
2. Manually trigger workflow from GitHub Actions UI

The workflow will:
- Build all Docker images
- Push to ACR
- Deploy to AKS

## Step 5: Configure DNS

Get the Ingress LoadBalancer IP:
```bash
kubectl get svc -n ingress-nginx ingress-nginx-controller
```

Create A records in your DNS provider:
- `mandlebulbtech.in` → LoadBalancer IP
- `www.mandlebulbtech.in` → LoadBalancer IP
- `api.mandlebulbtech.in` → LoadBalancer IP
- `mongo-express.mandlebulbtech.in` → LoadBalancer IP
- `pgadmin.mandlebulbtech.in` → LoadBalancer IP
- `kafka-ui.mandlebulbtech.in` → LoadBalancer IP

## Step 6: Configure SSL (Optional)

Install cert-manager:
```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.3/cert-manager.yaml
```

Create ClusterIssuer:
```bash
cat <<EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: your-email@example.com
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: nginx
EOF
```

## Access URLs

After deployment and DNS configuration:
- Frontend: https://mandlebulbtech.in
- API Gateway: https://api.mandlebulbtech.in
- Mongo Express: https://mongo-express.mandlebulbtech.in
- PgAdmin: https://pgadmin.mandlebulbtech.in
- Kafka UI: https://kafka-ui.mandlebulbtech.in

## Namespace Structure

- `gateway-ns`: API Gateway
- `auth-ns`: Auth Service + PostgreSQL
- `task-ns`: Task Service + PostgreSQL
- `analytics-ns`: Analytics Service + Workers + MongoDB
- `kafka-ns`: Kafka (Redpanda)
- `frontend-ns`: Frontend
- `devtools-ns`: Developer Tools (mongo-express, pgadmin, kafka-ui)

## Manual Deployment (Alternative)

If not using GitHub Actions, deploy manually:

```bash
# Apply namespaces
kubectl apply -f k8s/namespaces/

# Apply secrets and configmaps
kubectl apply -f k8s/auth-ns/postgres/secret.yaml
kubectl apply -f k8s/auth-ns/auth-service/
# ... (apply all secrets and configmaps)

# Deploy StatefulSets
kubectl apply -f k8s/auth-ns/postgres/sts.yaml
kubectl apply -f k8s/task-ns/task-postgres/sts.yaml
kubectl apply -f k8s/analytics-ns/mongo/sts.yaml
kubectl apply -f k8s/kafka-ns/kafka/sts.yaml

# Wait for StatefulSets
kubectl wait --for=condition=ready pod -l app=postgres -n auth-ns --timeout=300s
# ... (wait for all statefulsets)

# Deploy applications
kubectl apply -f k8s/gateway-ns/api-gateway/
kubectl apply -f k8s/auth-ns/auth-service/
# ... (apply all services)

# Deploy ingress
kubectl apply -f k8s/gateway-ns/api-gateway/ingress.yaml
kubectl apply -f k8s/frontend-ns/frontend/ingress.yaml
# ... (apply all ingress)
```

## Monitoring

Check deployment status:
```bash
kubectl get pods -A
kubectl get services -A
kubectl get ingress -A
kubectl get pvc -A
```

View logs:
```bash
kubectl logs -n <namespace> <pod-name>
kubectl logs -n <namespace> <pod-name> -f  # Follow logs
```

## Troubleshooting

Check pod status:
```bash
kubectl describe pod <pod-name> -n <namespace>
```

Check events:
```bash
kubectl get events -n <namespace> --sort-by='.lastTimestamp'
```

Check ingress:
```bash
kubectl describe ingress <ingress-name> -n <namespace>
```
