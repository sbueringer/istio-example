#!/bin/bash

CONTEXT=${1:-kubernetes-admin@kubernetes}
NAMESPACE=${2:-squash}

kubectl create --context $CONTEXT --namespace $NAMESPACE -f https://raw.githubusercontent.com/solo-io/squash/master/contrib/kubernetes/squash-server.yml
kubectl create --context $CONTEXT --namespace $NAMESPACE -f https://raw.githubusercontent.com/solo-io/squash/master/contrib/kubernetes/squash-client.yml

alias squash="squash --url=http://localhost:8001/api/v1/namespaces/squash/services/squash-server:http-squash-api/proxy/api/v2"

squash list attachments
