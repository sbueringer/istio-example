#!/bin/bash

WORKDIR=`echo $0 | sed -e s/install.sh//`
cd ${WORKDIR}

CONTEXT=${1:-kubernetes-admin@kubernetes}
ISTIO_DIR=${2:-/home/fedora/opt/istio/istio-0.4.0}

echo "Remove istio from $ISTIO_DIR using context $CONTEXT"

kubectl --context $CONTEXT delete namespace istio-system

echo "Waiting till namespaces are deleted"
while [ $(kubectl --context $CONTEXT get ns | grep "istio-system" | wc -l) -gt 0 ]; do
    echo -n "."
    sleep 5
done
echo "Namespaces are deleted"

kubectl --context $CONTEXT get clusterroles | grep istio | awk '{print "kubectl --context '$CONTEXT' delete clusterroles "$1}' | sh
kubectl --context $CONTEXT get clusterrolebindings | grep istio | awk '{print "kubectl --context '$CONTEXT' delete clusterrolebindings "$1}' | sh
kubectl --context $CONTEXT get psp | grep istio | awk '{print "kubectl --context '$CONTEXT' delete psp "$1}' | sh

kubectl --context $CONTEXT get crd | grep istio | awk '{print "kubectl --context '$CONTEXT' delete crd "$1}' | sh
kubectl --context $CONTEXT get initializerconfiguration | grep istio | awk '{print "kubectl --context '$CONTEXT' delete initializerconfiguration "$1}' | sh

# Get complete etcd dump of resources etc..
# export ETCDCTL_API=3; etcdctl --endpoints=10.6.0.3:2379 get / --prefix --keys-only | grep -v /registry/events | grep istio
