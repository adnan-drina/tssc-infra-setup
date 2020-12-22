#!/bin/bash

echo "Make sure you're connected to your OpenShift cluster with admin user before running this script"

mkdir /tmp/tssc-install
echo "/tmp/tssc-install Directory created"
cd /tmp/tssc-install


echo "*******************************************"
echo "Integrated Development Environment (IDE)"
echo "Installing RodeReady Workspaces 2.0 "
git clone https://github.com/adnan-drina/crw-install-cli.git \
    && cd crw-install-cli && sh ./install.sh && cd ..
echo "*******************************************"
echo "RodeReady Workspaces Done! "
echo "*******************************************"

echo "*******************************************"
echo "Continuous Integration (CI) Tool"
echo "OpenShift Pipelines (Tekton) "
git clone https://github.com/adnan-drina/tekton-cli-install.git \
    && cd tekton-cli-install && sh ./install.sh && cd ..
echo "*******************************************"
echo "OpenShift Pipelines Done! "
echo "*******************************************"

echo "*******************************************"
echo "Continuous Deployment (CD) Tool"
echo "Argo CD"
git clone https://github.com/adnan-drina/argo-cli-install.git \
    && cd argo-cli-install && sh ./install.sh && cd ..
echo "*******************************************"
echo "Argo CD Done! "
echo "*******************************************"

echo "*******************************************"
echo "Static Code Analysis Tool"
echo "SonarQube"
git clone https://github.com/adnan-drina/sonarqube-install-cli.git \
    && cd sonarqube-install-cli && sh ./install.sh && cd ..
echo "*******************************************"
echo "SonarQube Done! "
echo "*******************************************"

echo "*******************************************"
echo "Artifact Repository"
echo "Sonatype Nexus 3"
git clone https://github.com/adnan-drina/nexus3-community-install-cli.git \
    && cd nexus3-community-install-cli && sh ./install.sh && cd ..
echo "*******************************************"
echo "Sonatype Nexus 3   Done! "
echo "*******************************************"

echo "*******************************************"
echo "Image Registry / Container Image Scanning Tool"
echo "Red Hat Quay 3.3 / Clair v2"
git clone https://github.com/adnan-drina/quay-install-cli.git \
    && cd quay-install-cli && sh ./install.sh && cd ..
echo "*******************************************"
echo "Red Hat Quay 3.3 / Clair v2   Done! "
echo "*******************************************"

echo "*******************************************"
echo "Secret Management Tool"
echo "Sealed Secrets"
git clone https://github.com/adnan-drina/sealed-secrets-cli-install.git \
    && cd argo-cli-install && sh ./install.sh && cd ..
echo "*******************************************"
echo "Sealed Secrets Done! "
echo "*******************************************"

echo "*******************************************"
echo "Cleaning up tmp directory"
rm -f /tmp/tssc-install
echo "Done! "
echo "*******************************************"

wait 30
cat <<-EOF
############################################################################
############################################################################
  TSSC Workflow infrastructure installed!
  Give it a few minutes to finish deployments and then access components via following routes:

  RodeReady Workspaces: https://$(oc get route codeready -o template --template='{{.spec.host}}' -n codeready-workspaces)
  with OpenShift credentials

  Argo CD: https://$(oc get route argocd-server -o template --template='{{.spec.host}}' -n argocd)
  with OpenShift credentials

  SonarQube: https://$(oc get route sonarqube -o template --template='{{.spec.host}}' -n sonatqube)
  with admin/admin credentials

  Sonatype Nexus: https://$(oc get route nexus3 -o template --template='{{.spec.host}}' -n nexus-repository)
  with admin/admin123 credentials

  Red Hat Quay: https://$(oc get route quay -o template --template='{{.spec.host}}' -n quay)
  with quay/password credentials

############################################################################
############################################################################
EOF