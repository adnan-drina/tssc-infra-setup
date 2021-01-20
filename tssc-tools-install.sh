#!/bin/bash

echo "Make sure you're connected to your OpenShift cluster with admin user before running this script"

mkdir /tmp/tssc-install
echo "/tmp/tssc-install Directory created"
cd /tmp/tssc-install


echo "*******************************************"
echo "Integrated Development Environment (IDE)"
echo "Installing RodeReady Workspaces 2.0 "
echo "*******************************************"
git clone https://github.com/adnan-drina/crw-install-cli.git \
    && cd crw-install-cli && sh ./install.sh && cd ..
echo "*******************************************"
echo "CodeReady Workspaces Done! "
echo "*******************************************"
echo " "

echo " "
echo "*******************************************"
echo "Continuous Integration (CI) Tool"
echo "OpenShift Pipelines (Tekton) "
git clone https://github.com/adnan-drina/tekton-cli-install.git \
    && cd tekton-cli-install && sh ./install.sh && cd ..
echo "*******************************************"
echo "OpenShift Pipelines Done! "
echo "*******************************************"
echo " "

echo " "
echo "*******************************************"
echo "Continuous Deployment (CD) Tool"
echo "Argo CD"
git clone https://github.com/adnan-drina/argo-cli-install.git \
    && cd argo-cli-install && sh ./install.sh && cd ..
echo "*******************************************"
echo "Argo CD Done! "
echo "*******************************************"
echo " "

echo " "
echo "*******************************************"
echo "Static Code Analysis Tool"
echo "SonarQube"
git clone https://github.com/adnan-drina/sonarqube-install-cli.git \
    && cd sonarqube-install-cli && sh ./install.sh && cd ..
echo "*******************************************"
echo "SonarQube Done! "
echo "*******************************************"
echo " "

echo " "
echo "*******************************************"
echo "Artifact Repository"
echo "Sonatype Nexus 3"
git clone https://github.com/adnan-drina/nexus3-community-install-cli.git \
    && cd nexus3-community-install-cli && sh ./install.sh && cd ..
echo "*******************************************"
echo "Sonatype Nexus 3   Done! "
echo "*******************************************"
echo " "

echo " "
echo "*******************************************"
echo "Image Registry / Container Image Scanning Tool"
echo "Red Hat Quay 3.3 / Clair v2"
git clone https://github.com/adnan-drina/quay-install-cli.git \
    && cd quay-install-cli && sh ./install.sh && cd ..
echo "*******************************************"
echo "Red Hat Quay 3.3 / Clair v2   Done! "
echo "*******************************************"
echo " "

echo " "
echo "*******************************************"
echo "Secret Management Tool"
echo "Sealed Secrets"
git clone https://github.com/adnan-drina/sealed-secrets-cli-install.git \
    && cd sealed-secrets-cli-install && sh ./install.sh && cd ..
echo "*******************************************"
echo "Sealed Secrets Done! "
echo "*******************************************"
echo " "

echo " "
echo "*******************************************"
echo "Cleaning up tmp directory"
rm -rf /tmp/tssc-install
echo "Done! "
echo "*******************************************"
echo " "
echo " "

# wait
sleep 30
ARGO_POD="$(oc get pods -o name -n argocd | grep argocd-server-)"
oc -n argocd wait --for=condition=Ready ${ARGO_POD}

SONAR_POD="$(oc get pods -o name -n sonarqube | grep sonarqube)"
oc -n sonarqube wait --for=condition=Ready ${SONAR_POD}

NEXUS_POD="$(oc get pods -o name -n nexus-repository | grep nexus)"
oc -n nexus-repository wait --for=condition=Ready ${NEXUS_POD}

QUAY_POD1="$(oc get pods -o name -n quay | grep quayecosystem-quay-postgresql-)"
oc -n quay wait --for=condition=Ready ${QUAY_POD1}
echo "quayecosystem-quay-postgresql ready!"
QUAY_POD2="$(oc get pods -o name -n quay | grep quayecosystem-quay-config-)"
oc -n quay wait --for=condition=Ready ${QUAY_POD2}
echo "quayecosystem-quay-config ready!"

CRW_POD="$(oc get pods -o name -n codeready-workspaces | grep codeready-)"
oc -n codeready-workspaces wait --for=condition=Ready ${CRW_POD}

cat <<-EOF
############################################################################
############################################################################
  TSSC Workflow infrastructure installed!
  Give it a few minutes to finish deployments and then access components via following routes:

  CodeReady Workspaces: https://$(oc get route codeready -o template --template='{{.spec.host}}' -n codeready-workspaces)
  with OpenShift credentials

  Argo CD: https://$(oc get route argocd-server -o template --template='{{.spec.host}}' -n argocd)
  with OpenShift credentials

  SonarQube: https://$(oc get route sonarqube -o template --template='{{.spec.host}}' -n sonarqube)
  with admin/admin credentials

  Sonatype Nexus: http://$(oc get route nexus -o template --template='{{.spec.host}}' -n nexus-repository)
  with admin/admin123 credentials

  Red Hat Quay: https://$(oc get route quayecosystem-quay -o template --template='{{.spec.host}}' -n quay)
  with quay/password credentials

############################################################################
############################################################################
EOF