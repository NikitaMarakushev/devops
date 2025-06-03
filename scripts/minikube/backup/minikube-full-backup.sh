#!/bin/bash
BACKUP_DIR="minikube-backup-$(date +%Y-%m-%d)"

mkdir -p "$BACKUP_DIR"
cd "$BACKUP_DIR"

mkdir -p resources
for ns in $(kubectl get ns -o jsonpath='{.items[*].metadata.name}'); do
  kubectl get all -n "$ns" -o yaml > "resources/$ns-all.yaml"
done

kubectl get pods -n default -o=jsonpath='{.items[0].metadata.name}' | xargs -I {} kubectl cp default/{}:/data pvc-data-{}

helm list -A -o yaml > helm-releases.yaml

cp -r ~/.minikube .
cp ~/.kube/config .

echo "Backup saved to $BACKUP_DIR"