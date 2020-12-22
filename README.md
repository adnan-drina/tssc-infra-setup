# tssc-infra-setup
[Trusted Software Supply Chain (TSSC)](https://rhtconsulting.github.io/tsc-docs/#tssc) Infrastructure installation on OpenShift

This Repository is intended to help automate the rollout of infrastructure components needed for implementation of TSSC Workflow as pictured below.
![Alt text](TSSC_Workflow_High_Level.png?raw=true "TSSC Workflow High Level")

## TSSC Workflow Tools

| Component                                 | Implementation tool                       |
| :-------------                            | :-------------                            |
| Container Platform                        | OpenShift 4.6                             |
| Identity / Authentication / Authorization | OpenShift SSO                             |
| Integrated Development Environment (IDE)  | RodeReady Workspaces 2.0                  |
| Application Language Packaging Tool       | Maven 3.6                                 |
| Application Language Unit Test Tool       | JUnit                                     |
| Source Control Tool                       | GitHub                                    |
| Secret Management Tool                    | Bitnami "Sealed Secrets" for Kubernetes   |
| Continuous Integration (CI) Tool          | OpenShift Pipelines (Tekton)              |
| Static Code Analysis Tool                 | SonarQube                                 |
| Binary Artifact Upload Tool               | Maven                                     |
| Artifact Repository                       | Sonatype Nexus 3                          |
| Container Image Build Tool                | Buildah                                   |
| Container Image Upload Tool               | Skopeo                                    |
| Image Registry                            | Red Hat Quay 3.3                          |
| Container Image Scanning Tool             | Clair v2                                  |
| Runtime Vulnerability Scanning Tool       | Container Security Operator               |
| Continuous Deployment (CD) Tool           | Argo CD                                   |

| UnMapped Components                       |
| :------------- 
| Container Image Unit Test Tool
| Kubernetes Resources Creation Tool
| User Acceptance Testing (UAT) Tool
| Performance Testing Tool
| Peer Review Tool
| Canary Testing Tool
| Discussion

fabric8 | kustomize | s2i | operators
kam bootstrap
sealed-secrets
istio | health, livens probe
Docker notary
cekit.io