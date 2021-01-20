#!/bin/bash

echo "Make sure you're connected to your OpenShift cluster with admin user before running this script"

echo "*******************************************"
echo "Creating CatalogSource for the RedHatGov operator catalog"
echo "*******************************************"
oc apply -f - << EOF
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: redhatgov-operators
  namespace: openshift-marketplace
spec:
  sourceType: grpc
  image: quay.io/redhatgov/operator-catalog:latest
  displayName: Red Hat NAPS Community Operators
  publisher: RedHatGov
EOF

echo "*******************************************"
echo "Creating a project named devsecops for pipeline tooling"
echo "*******************************************"
oc new-project devsecops

echo "*******************************************"
echo "Deleting the limit range for the new project"
echo "*******************************************"
oc delete limitrange --all -n devsecops

echo "*******************************************"
echo "Create OperatorGroup in devsecops namespace"
echo "*******************************************"
oc apply -f - << EOF
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: ploigos-software-factory
  namespace: devsecops
spec:
  targetNamespaces:
    - devsecops
EOF

echo "*******************************************"
echo "Install Ploigos Software Factory Operator"
echo "*******************************************"
oc apply -f - << EOF
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ploigos-software-factory-operator
  namespace: devsecops
spec:
  channel: alpha
  installPlanApproval: Automatic
  name: ploigos-software-factory-operator
  source: redhatgov-operators
  sourceNamespace: openshift-marketplace
EOF

echo "*******************************************"
echo "Wait for Ploigos subscription to become ready"
echo "*******************************************"
sleep 90
PLOIGOS="$(oc get sub -o name -n devsecops | grep ploigos)"
oc -n devsecops wait --timeout=120s --for=condition=CatalogSourcesUnhealthy=False ${PLOIGOS}

echo "*******************************************"
echo "Create a new TsscPlatform CustomResource"
echo "*******************************************"
oc apply -f - << EOF
apiVersion: redhatgov.io/v1alpha1
kind: TsscPlatform
metadata:
  name: tsscplatform
  namespace: devsecops
spec: {}
EOF

echo "*******************************************"
echo "Wait for Jenkins to become ready"
echo "*******************************************"
sleep 120

echo "*******************************************"
echo "Create a new TsscPipeline CustomResource"
echo "*******************************************"
oc apply -n devsecops -f - << EOF
apiVersion: redhatgov.io/v1alpha1
kind: TsscPipeline
metadata:
  name: tsscpipeline
  namespace: devsecops
spec: {}
EOF