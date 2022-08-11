kubectl config use-context tap-build-cluster-admin@tap-build-cluster

kubectl get deliverable spring-sensors --namespace tap-dev -o json > deliverable-temp.json
jq 'del(.status)' deliverable-temp.json | jq 'del(.metadata.ownerReferences)' > deliverable.json && rm -rf deliverable-temp.json
jq '.spec.source.git.ref.branch |= "develop"' deliverable.json > deliverable-staging.json
jq '.spec.source.git.ref.branch |= "main"' deliverable.json > deliverable-live.json
rm -rf deliverable.json

# Apply deliverable to staging cluster (This points to develop branch)
kubectl config use-context tap-run-cluster-admin@tap-run-cluster
kubectl apply -f deliverable-staging.json

# Apply deliverable to prod/live cluster (This points to main branch)
kubectl config use-context tap-run-prod-cluster-admin@tap-run-prod-cluster
kubectl apply -f deliverable-live.json