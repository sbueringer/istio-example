#!/bin/bash

WORKDIR=`echo $0 | sed -e s/install.sh//`
cd ${WORKDIR}

CONTEXT=${1:-kubernetes-admin@kubernetes}
NAMESPACE=${2:-squash}

kubectl apply --context $CONTEXT --namespace $NAMESPACE -f ./squash-client.yml
kubectl apply --context $CONTEXT --namespace $NAMESPACE -f ./squash-server.yml

alias squash="squash --url=http://localhost:8001/api/v1/namespaces/squash/services/squash-server:http-squash-api/proxy/api/v2"

squash list attachments
