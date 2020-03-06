#!/bin/bash -ex

if [ -z "$DEVSHELL_PROJECT_ID" ]; then
    read -p ">>> What is your GCP project ID? (e.g., jdoe-sps-spring20) " DEVSHELL_PROJECT_ID
fi

gcloud config set project $DEVSHELL_PROJECT_ID

echo ">>> Creating a service account 'cloudshell-devserver@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com' in your project $DEVSHELL_PROJECT_ID..."

SA_NAME=cloudshell-devserver
SA_EMAIL=$SA_NAME@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com
gcloud iam service-accounts create $SA_NAME
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member serviceAccount:$SA_EMAIL --role roles/editor

echo ">>> Creating a service account key and adding GOOGLE_APPLICATION_CREDENTIALS environment variable..."
KEY_FILE_PATH=$HOME/application_default_credentials.json
gcloud iam service-accounts keys create $KEY_FILE_PATH --iam-account $SA_EMAIL
echo "export GOOGLE_APPLICATION_CREDENTIALS=$KEY_FILE_PATH" >> ~/.bashrc

echo ">>> Done. Exit the current shell and re-open a new shell to make this effective."
