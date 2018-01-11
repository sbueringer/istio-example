#!/bin/bash

NAMESPACE=${2:-squash}

kubectl create --context $CONTEXT --namespace $NAMESPACE delete ns squash