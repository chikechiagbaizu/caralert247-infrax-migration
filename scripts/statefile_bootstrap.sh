#!/bin/bash
set -e 

# --- CONFIGURATION ---
PROJECT_ID="caralert247-488712"
REGION="europe-west2"
BUCKET_NAME="${PROJECT_ID}-terraform-state"
KEYRING_NAME="tf-state-keyring"
KEY_NAME="tf-state-key"

echo "🚀 Checking and Initializing Terraform Backend for $PROJECT_ID..."

# 1. Enable Required APIs
gcloud services enable \
    storage.googleapis.com \
    cloudkms.googleapis.com \
    compute.googleapis.com \
    --project="$PROJECT_ID"

# 2. Force creation of GCS Service Identity (Prevents "Service account does not exist" errors)
gcloud beta services identity create --service=storage.googleapis.com --project="$PROJECT_ID" || true

# 3. Create KMS Infrastructure with Existence Checks
if ! gcloud kms keyrings describe "$KEYRING_NAME" --location "$REGION" --project "$PROJECT_ID" &>/dev/null; then
    echo "Creating KeyRing..."
    gcloud kms keyrings create "$KEYRING_NAME" --location "$REGION" --project "$PROJECT_ID"
else
    echo "✅ KeyRing '$KEYRING_NAME' already exists. Skipping."
fi

if ! gcloud kms keys describe "$KEY_NAME" --location "$REGION" --keyring "$KEYRING_NAME" --project "$PROJECT_ID" &>/dev/null; then
    echo "Creating KMS Key..."
    gcloud kms keys create "$KEY_NAME" \
        --location "$REGION" \
        --keyring "$KEYRING_NAME" \
        --purpose "encryption" \
        --project "$PROJECT_ID"
else
    echo "✅ Key '$KEY_NAME' already exists. Skipping."
fi

# 4. Grant GCS Service Identity access to the Key
PROJECT_NUMBER=$(gcloud projects describe "$PROJECT_ID" --format='value(projectNumber)')
GCS_SERVICE_ACCOUNT="service-${PROJECT_NUMBER}@gs-project-accounts.iam.gserviceaccount.com"

echo "Setting IAM policy for GCS service account..."
gcloud kms keys add-iam-policy-binding "$KEY_NAME" \
    --location "$REGION" \
    --keyring "$KEYRING_NAME" \
    --member "serviceAccount:${GCS_SERVICE_ACCOUNT}" \
    --role "roles/cloudkms.cryptoKeyEncrypterDecrypter" \
    --project "$PROJECT_ID" --quiet

# 5. Create the Secured Bucket with Existence Check
if ! gcloud storage buckets describe "gs://$BUCKET_NAME" --project="$PROJECT_ID" &>/dev/null; then
    echo "Creating Storage Bucket..."
    gcloud storage buckets create "gs://$BUCKET_NAME" \
        --project="$PROJECT_ID" \
        --location="$REGION" \
        --uniform-bucket-level-access \
        --public-access-prevention
else
    echo "✅ Bucket 'gs://$BUCKET_NAME' already exists. Skipping."
fi

# 6. Apply/Verify Production Safety Settings
echo "Ensuring versioning and encryption are enabled..."
gcloud storage buckets update "gs://$BUCKET_NAME" --versioning --project="$PROJECT_ID"

KMS_KEY_ID="projects/$PROJECT_ID/locations/$REGION/keyRings/$KEYRING_NAME/cryptoKeys/$KEY_NAME"
gcloud storage buckets update "gs://$BUCKET_NAME" --versioning --default-encryption-key="$KMS_KEY_ID" --project="$PROJECT_ID"

echo "✅ Success! Backend Ready: gs://$BUCKET_NAME"