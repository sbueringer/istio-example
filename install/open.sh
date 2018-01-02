#!/bin/bash

CONTEXT=${1:-kubernetes-admin@kubernetes}
SERVICES=${2:-grafana prometheus zipkin}
#SERVICES=${2:-grafana prometheus servicegraph zipkin}

for svc in $SERVICES
do
    CLUSTERIP=$(kubectl --context $CONTEXT --namespace istio-system get svc $svc -o jsonpath='{.spec.clusterIP}')
    PORT=$(kubectl --context $CONTEXT --namespace istio-system get svc $svc -o jsonpath='{.spec.ports[*].port}')

    echo Open service $svc: $CLUSTERIP:$PORT
    xdg-open http://$CLUSTERIP:$PORT
done