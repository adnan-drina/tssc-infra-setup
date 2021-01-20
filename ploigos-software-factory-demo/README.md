Based on the [ploigos/ploigos-software-factory-operator](https://github.com/ploigos/ploigos-software-factory-operator) project
---
### TSSC Demo with a Reference App

Deploy and configure a TSSC Platform and Pipeline for the http://gitea.apps.tssc.rht-set.com/tssc-references/reference-quarkus-mvn-jenkins[TSSC Quarkus reference app]; this includes importing and updating the config of the git repos. You can deploy this using the steps below:

Step 1. Login to an OpenShift cluster (tested on 4.4 or above) as a `cluster-admin`

Step 2. Create a `CatalogSource` to import the RedHatGov operator catalog.

```yaml
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

```
Step 3. Create a project named **devsecops** for your pipeline tooling to live.

```shell script
oc new-project devsecops
```

Step 4. *If you are using an RHPDS-provisioned cluster:*  delete the limit range for the new project. RHPDS sometimes sets default CPU / memory limits that are too restrictive for certain Pods that the operator will create.

```shell script
oc delete limitrange --all -n devsecops
```

Step 5. In the OpenShift Web Console, navigate to **Operators -> OperatorHub** and search for "Ploigos Software Factory Operator". Select it and click **Install**

Step 6. Set **Installation Mode** to *A specific namespace on the cluster* and set **Installed Namespace** to *devsecops*.

Step 7. Leave other options as default and click **Install** once more.

Step 8. *If you're using an RHPDS-provisioned cluster, you can skip this step, since this secret is created as part of the default provisioning template.* Create a `.dockerconfigjson` secret containing a pull token for registry.redhat.io. It is recommended to generate a new service account before a workshop and delete it after, as this token is available in each of the users' projects (and can be used in the future if the service account isn't deleted). To get a service account:
  * Go to https://access.redhat.com/terms-based-registry/
  * Login with your Red Hat credentials, then go to Service Accounts (upper right corner) and create a new service account. 
  * Click on the name of the service account, go to the 'Docker Configuration' tab, click 'view its contents' 
  * Copy the contents and save it `~/.docker/config.json`
  * Create the config.json file if not already existed `vi ~/.docker/config.json` and paste the contents there.
  * Run the below command to create the pull-secret secret in the openshift-config namespace
    ```shell script
    oc create secret generic pull-secret --from-file=.dockerconfigjson=</path/to/.docker/config.json> --type=kubernetes.io/dockerconfigjson -n openshift-config
    ```
  * Remember to replace `</path/to/.docker/config.json>` with the location where the `config.json` file is saved.

Step 9. On the Ploigos Software Factory Operator page, create a new `TsscPlatform` CustomResource.

Step 10. If you modified the name of your pull secret in Step 7, provide the corresponding values for **Tsscplatform -> Pull Secret** as needed. Otherwise, you can leave this blank.

Step 11. Watch the logs of the `tssc-operator-controller-manager` pod, and wait for:
```shell script
PLAY RECAP *********************************************************************
  [0;33mlocalhost[0m                  : [0;32mok=32  [0m [0;33mchanged=10  [0m unreachable=0    failed=0    [0;36mskipped=17  [0m rescued=0    ignored=0
```

- This message indicates that the Reconciliation is complete. It should appear within 8-10 minutes.

Step 12. Then create a `TsscPipeline` instance, which should create and start your pipeline job in Jenkins:

```yaml
oc apply -n devsecops -f - << EOF
apiVersion: redhatgov.io/v1alpha1
kind: TsscPipeline
metadata:
  name: tsscpipeline
spec: {}
EOF
```

Note:
This use case supports RHSSO with or without a backing Identity Provider. Without a backing IP KeyCloak users can be created.