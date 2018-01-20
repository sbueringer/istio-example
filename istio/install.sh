#!/bin/bash

WORKDIR=`echo $0 | sed -e s/install.sh//`
cd ${WORKDIR}

# Secrets
if [ -e ./../.secrets ]
then
    echo "Sourcing ./../.secrets"
    source ./../.secrets
fi

CONTEXT=${1:-kubernetes-admin@kubernetes}
ISTIO_DIR=${2:-/home/fedora/opt/istio/istio-0.4.0}

echo "Installing istio from $ISTIO_DIR using context $CONTEXT"

# Istio

~/code/detss/drhub/istio/certs/istio/deploySecret.sh $CONTEXT

kubectl --context $CONTEXT apply -f $ISTIO_DIR/install/kubernetes/istio-auth.yaml
kubectl --context $CONTEXT apply -f $ISTIO_DIR/install/kubernetes/istio-initializer.yaml

kubectl --context $CONTEXT apply -f $ISTIO_DIR/install/kubernetes/addons/grafana.yaml
kubectl --context $CONTEXT apply -f $ISTIO_DIR/install/kubernetes/addons/prometheus.yaml
kubectl --context $CONTEXT apply -f $ISTIO_DIR/install/kubernetes/addons/servicegraph.yaml
kubectl --context $CONTEXT apply -f $ISTIO_DIR/install/kubernetes/addons/zipkin.yaml

# Helloworld Sample
NAMESPACE=helloworld
kubectl --context $CONTEXT create namespace helloworld
kubectl --context $CONTEXT --namespace $NAMESPACE apply -f $ISTIO_DIR/samples/helloworld/helloworld.yaml
