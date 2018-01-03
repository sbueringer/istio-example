#!/bin/bash

CONTEXT=${1:-kubernetes-admin@kubernetes}
NAMESPACE=${2:-brigade}
SERVICES=${3:-kashti-kashti}

for svc in $SERVICES
do
    CLUSTERIP=$(kubectl --context $CONTEXT --namespace $NAMESPACE get svc $svc -o jsonpath='{.spec.clusterIP}')
    PORT=$(kubectl --context $CONTEXT --namespace $NAMESPACE get svc $svc -o jsonpath='{.spec.ports[*].port}')

    echo Open service $svc: $CLUSTERIP:$PORT
    xdg-open http://$CLUSTERIP:$PORT
done