mkdir -p minikube-backup/resources

for ns in $(kubectl get ns -o jsonpath='{.items[*].metadata.name}'); do
  mkdir -p "minikube-backup/resources/$ns"
  for resource in $(kubectl api-resources --namespaced=true -o name); do
    kubectl get "$resource" -n "$ns" -o yaml > "minikube-backup/resources/$ns/$resource.yaml"
  done
done

for resource in $(kubectl api-resources --namespaced=false -o name); do
  kubectl get "$resource" -o yaml > "minikube-backup/resources/cluster-$resource.yaml"
done