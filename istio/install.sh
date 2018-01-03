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

#kubectl --context $CONTEXT apply -f custom/imagepullsecret.yaml.secret
#kubectl --context $CONTEXT apply -f custom/istio-system-istio-psp.yaml
#kubectl --context $CONTEXT apply -f custom/istio-system-networkpolicies.yaml

#./../certs/istio/deploySecret.sh

kubectl --context $CONTEXT apply -f $ISTIO_DIR/install/kubernetes/istio-auth.yaml

# Initializer: modified apiserver config:
# --runtime-config    Add: admissionregistration.k8s.io/v1alpha1
# --admission-control Add: Initializers
# Restart ApiServer systemctl restart kube-apiserver
kubectl --context $CONTEXT apply -f $ISTIO_DIR/install/kubernetes/istio-initializer.yaml

kubectl --context $CONTEXT apply -f $ISTIO_DIR/install/kubernetes/addons/grafana.yaml
kubectl --context $CONTEXT apply -f $ISTIO_DIR/install/kubernetes/addons/prometheus.yaml
kubectl --context $CONTEXT apply -f $ISTIO_DIR/install/kubernetes/addons/servicegraph.yaml
kubectl --context $CONTEXT apply -f $ISTIO_DIR/install/kubernetes/addons/zipkin.yaml

# Helloworld Sample
#NAMESPACE=helloworld
#kubectl --context $CONTEXT create namespace helloworld
#kubectl --context $CONTEXT --namespace $NAMESPACE apply -f custom/helloworld-networkpolicies.yaml
#kubectl --context $CONTEXT apply -f custom/helloworld-istio-psp.yaml
#kubectl --context $CONTEXT --namespace $NAMESPACE apply -f samples/helloworld/helloworld.yaml
