# SantaFe AKS and ACR

This repository provisions a resource group, network, Azure Container Registry
(ACR), and Azure Kubernetes Service (AKS) cluster. The AKS kubelet receives the
`AcrPull` role on the managed ACR, so workloads can pull private images without
embedding registry credentials in manifests.

## Validate and plan

Run these commands from an environment directory:

```powershell
terraform init
terraform fmt -check -recursive ..\..
terraform validate
terraform plan -var-file=terraform.tfvars
```

The environment variable definitions validate naming, ACR SKU, node-pool
autoscaling bounds, network settings, and API-server CIDR inputs before a plan
can be created.

## Deploy manifests

After applying the infrastructure, configure `kubectl` from the sensitive
kubeconfig output and replace the image in manifests with the
`acr_login_server` output:

```powershell
terraform apply -var-file=terraform.tfvars
terraform output -raw aks_kube_config | Set-Content -NoNewline .\kubeconfig
$env:KUBECONFIG = (Resolve-Path .\kubeconfig)
kubectl apply -f ..\..\manifests\
```

Do not commit the generated `kubeconfig` file. The manifests directory is
expected to be supplied by the application deployment.
