variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "yashvi-microservices-rg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "centralindia"
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "yashvi-aks-cluster"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.33" # PLACEHOLDER: Update to desired version
}

variable "node_count" {
  description = "Number of nodes in default node pool"
  type        = number
  default     = 2 # PLACEHOLDER: Adjust based on requirements
}

variable "node_vm_size" {
  description = "VM size for nodes"
  type        = string
  default     = "Standard_D2s_v3" # PLACEHOLDER: Adjust based on requirements
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "yashviacr" # PLACEHOLDER: Must be globally unique
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "production"
    Project     = "yashvi-microservices"
    ManagedBy   = "terraform"
  }
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "client_id" {
  description = "Azure Service Principal Client ID"
  type        = string
}

variable "client_secret" {
  description = "Azure Service Principal Client Secret"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}
