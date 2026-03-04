# CarAlert247 Infrastructure Migration (GCP)

This repository contains the Terraform Infrastructure as Code (IaC) for migrating CarAlert247 services to Google Cloud Platform. It demonstrates a modular, scalable architecture using GKE for container orchestration and Cloud Run for serverless workloads.

---

## 🏗️ Architecture Overview

The infrastructure is designed with high availability and security best practices in mind:

- **VPC-Native GKE Cluster:** A regional/zonal standard cluster configured with alias IP ranges for Pods and Services.
- **Networking Layer:** A custom VPC with private subnets and Private Google Access enabled to ensure secure node communication without public IPs.
- **Identity & Access (IAM):** Dedicated Service Accounts for GKE nodes with minimum required permissions (Logging, Monitoring, Artifact Registry).
- **Serverless Stack:** Cloud Run (v2) integration for lightweight, auto-scaling API services.
- **Artifact Management:** Centralized Docker image storage via Artifact Registry.

---

## 📁 Repository Structure

```plaintext
.
├── environment/staging/      # Environment-specific configuration
│   ├── main.tf               # Primary entry point (calls modules)
│   ├── variables.tf          # Variable definitions
│   ├── staging.auto.tfvars   # Actual values for staging
│   └── backend.tf            # Remote state configuration
└── modules/                  # Reusable infrastructure components
    ├── gke/                  # GKE Cluster & Node Pool definitions
    ├── network/              # VPC, Subnets, and Firewall rules
    ├── cloudrun/             # Cloud Run v2 Service definitions
    └── artifact-registry/    # Container registry setup
```

---

## 🚀 Deployment Guide

### Prerequisites

- **Google Cloud Project:** An active GCP project with billing enabled.
- **GCP CLI:** Authenticated via `gcloud auth application-default login`.
- **Terraform:** Version `1.0.0+` installed locally.

### Step 1: Initialize

Navigate to the staging environment and initialize the providers and modules.

```bash
cd environment/staging
terraform init
```

### Step 2: Configuration

Ensure your `staging.auto.tfvars` contains the correct project and region details.

> **Note:** GKE nodes are configured with 50GB `pd-balanced` disks to remain within standard project quotas.

### Step 3: Plan & Apply

```bash
terraform plan -out=staging.tfplan
terraform apply "staging.tfplan"
```

---

## 🛠️ Lessons Learned (PoC Notes)

During the development of this PoC, several critical GCP-specific configurations were addressed:

- **Quota Management:** Encountered `GCE_QUOTA_EXCEEDED` for SSD storage. Resolved by switching GKE boot disks to `pd-balanced` and reducing size to 50GB.
- **Connectivity:** Implemented Private Google Access on the subnetwork to allow private GKE nodes to reach Google APIs and register with the Control Plane.
- **Module Dependencies:** Used Terraform `depends_on` blocks to ensure IAM roles are fully propagated before GKE node pools attempt to initialize.

---

## 🛡️ Security Features

- **No Default Node Pool:** The cluster is created and immediately stripped of its default pool to ensure all worker nodes are managed as separate, granular resources.
- **Least Privilege:** GKE nodes do not use the default Compute Engine service account; they use a custom-hardened identity.
- **VPC-Native:** Modern networking approach that avoids the overhead of alias IP routing and improves pod-to-pod communication performance.
