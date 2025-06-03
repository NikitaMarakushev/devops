kubectl get pods --all-namespaces -o=jsonpath='{range .items[*]}{.metadata.namespace}/{.metadata.name}{"\n"}{end}' | while read -r pod; do
  ns=$(echo "$pod" | cut -d'/' -f1)
  pod_name=$(echo "$pod" | cut -d'/' -f2)
  for volume in $(kubectl get pod "$pod_name" -n "$ns" -o=jsonpath='{.spec.volumes[*].name}'); do
    kubectl cp "$ns/$pod_name:/path/to/data" "minikube-backup/pv/$pod_name-$volume" -c <container_name>
  done
done