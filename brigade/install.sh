#!/bin/bash

CONTEXT=${1:-kubernetes-admin@kubernetes}
NAMESPACE=${2:-brigade}

BRIGADE_FOLDER=~/opt/brigade

kubectl create ns $NAMESPACE

helm init

helm upgrade --install --namespace $NAMESPACE brigade $BRIGADE_FOLDER/brigade/charts/brigade

svc=brigade-brigade-api
CLUSTERIP=$(kubectl --context $CONTEXT --namespace $NAMESPACE get svc $svc -o jsonpath='{.spec.clusterIP}')
PORT=$(kubectl --context $CONTEXT --namespace $NAMESPACE get svc $svc -o jsonpath='{.spec.ports[*].port}')

echo brigade api running at $CLUSTERIP:$PORT

helm upgrade --install --namespace $NAMESPACE --set brigade.apiServer=http://$CLUSTERIP:$PORT kashti $BRIGADE_FOLDER/kashti/charts/kashti