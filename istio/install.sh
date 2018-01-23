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
kubectl --context $CONTEXT create namespace $NAMESPACE
kubectl --context $CONTEXT --namespace $NAMESPACE apply -f $ISTIO_DIR/samples/helloworld/helloworld.yaml

# BookInfo Sample
NAMESPACE=bookinfo
kubectl --context $CONTEXT create namespace $NAMESPACE
kubectl --context $CONTEXT --namespace $NAMESPACE apply -f $ISTIO_DIR/samples/bookinfo/kube/bookinfo.yaml

kubectl --context $CONTEXT get svc,po
GATEWAY_URL=ingress.istio.io
curl -o /dev/null -s -w "%{http_code}\n" http://${GATEWAY_URL}/productpage


#TODO: https://istio.io/docs/guides/intelligent-routing.html
#TODO: https://istio.io/docs/guides/telemetry.html

#TODO: https://istio.io/docs/tasks/





