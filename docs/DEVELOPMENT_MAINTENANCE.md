# How to upgrade the HAProxy Package chart

BigBang makes modifications to the upstream helm chart. The full list of changes is at the end of  this document.

---

1. Find the current and latest release notes from the [release page](https://github.com/haproxytech/helm-charts/releases?q=haproxy-1&expanded=true). Be aware of changes that are included in the upgrade. Take note of any manual upgrade steps that customers might need to perform, if any.
1. Clone the repo locally and checkout the release tag from [the upstream repo](https://github.com/haproxytech/helm-charts/tree/main/haproxy).
1. Do a diff of the current BB package against the upstream chart using [your favorite diff tool](https://marketplace.visualstudio.com/items?itemName=L13RARY.l13-diff) to become aware of any significant chart changes. You can see where the current helm chart came from by inspecting the [chart/Kptfile](../chart/Kptfile).
1. Create a development branch and merge request from the Gitlab issue.
1. Merge changes from the upstream chart and template into the existing HAProxy package code, again using [your favorite diff tool](https://marketplace.visualstudio.com/items?itemName=L13RARY.l13-diff) -or- (if you're feeling lucky) by using `kpt` as in the two steps below:
    1. In `chart/Kptfile` update `.upstream.git.ref` to the tag of the release you found earlier.
    1. `kpt pkg update chart --strategy force-delete-replace`
1. Reference the **"Modifications made to upstream chart"** section below and re-apply these changes to the merged package. If for some reason additional changes to the chart or template are required to get the new version of `haproxy` to work with Big Bang... take note of these additional changes in the same modification section below. This will preserve the Big Bang specific changes for future upgrades.
1. Update [CHANGELOG.md](../CHANGELOG.md) by adding an entry at the top detailing the changes of the new haproxy chart as appropriate.
1. Update [README.md](../README.md) following the [gluon library script](https://repo1.dso.mil/platform-one/big-bang/apps/library-charts/gluon/-/blob/master/docs/bb-package-readme.md)
1. Update [chart/Chart.yaml](../chart/Chart.yaml) to the appropriate `version` and `appVersion`. The annotation version should match the `appVersion` (you will likely need to change that in the modifications below).
    ```yaml
    version: X.X.X-bb.X
    appVersion: X.X.X
    annotations:
      bigbang.dev/applicationVersions: |
        - HAProxy: vX.X.X
    ```
1. Use a development environment to deploy and test HAProxy. See more detailed testing instructions below. Also test an upgrade by deploying the old version first and then deploying the new version.
1. When the Package pipeline runs expect the cypress tests to fail due to UI changes.
1. Update the [README.md](../README.md) and the **"Modifications made to upstream chart"** section below again if you have made any additional changes during the upgrade/testing process.

# Testing new HAProxy version

## Branch/Tag Config

If you'd like to install from a specific branch or tag, then the code block under haproxy needs to be uncommented and used to target your changes.

For example, this would target the `renovate/ironbank` branch.

```
addons:
  haproxy:
    <other config/labels>
    ...
    ...

    # Add git branch or tag information to test against a specific branch or tag instead of using `main`
    # Must set the unused label to null
    git:
      tag: null
      branch: "renovate/ironbank"
```

## Cluster setup

⚠️ Always make sure your local bigbang repo is current before deploying.

1. Export your Ironbank/Harbor credentials (this can be done in your `~/.bashrc` or `~/.zshrc` file if desired). These specific variables are expected by the `k3d-dev.sh` script when deploying metallb, and are referenced in other commands for consistency:

    ```sh
    export REGISTRY_USERNAME='<your_username>'
    export REGISTRY_PASSWORD='<your_password>'
    ```

1. Export the path to your local bigbang repo (without a trailing `/`):

   ⚠️ Note that wrapping your file path in quotes when exporting will break expansion of `~`.

    ```sh
    export BIGBANG_REPO_DIR=<absolute_path_to_local_bigbang_repo>
    ```

    e.g.

    ```sh
    export BIGBANG_REPO_DIR=~/repos/bigbang
    ```

1. Run the [k3d_dev.sh](https://repo1.dso.mil/big-bang/bigbang/-/blob/master/docs/assets/scripts/developer/k3d-dev.sh) script to deploy a dev cluster (use the default deploy with no additional flags):

    ```sh
    "${BIGBANG_REPO_DIR}/docs/assets/scripts/developer/k3d-dev.sh"
    ```

1. Export your kubeconfig:

    ```sh
    export KUBECONFIG=~/.kube/<your_kubeconfig_file>
    ```

    e.g.

    ```sh
    export KUBECONFIG=~/.kube/Christopher.Galloway-dev-config
    ```

1. [Deploy flux to your cluster](https://repo1.dso.mil/big-bang/bigbang/-/blob/master/scripts/install_flux.sh):

    ```sh
    "${BIGBANG_REPO_DIR}/scripts/install_flux.sh -u ${REGISTRY_USERNAME} -p ${REGISTRY_PASSWORD}"
    ```

## Deploy Bigbang

From the root of this repo, run one of the following deploy command:

  ```sh
  helm upgrade -i bigbang ${BIGBANG_REPO_DIR}/chart/ -n bigbang --create-namespace \
  --set registryCredentials.username=${REGISTRY_USERNAME} --set registryCredentials.password=${REGISTRY_PASSWORD} \
  -f https://repo1.dso.mil/big-bang/bigbang/-/raw/master/tests/test-values.yaml \
  -f https://repo1.dso.mil/big-bang/bigbang/-/raw/master/chart/ingress-certs.yaml \
  -f https://repo1.dso.mil/big-bang/bigbang/-/raw/master/docs/assets/configs/example/dev-sso-values.yaml \
  -f docs/dev-overrides/minimal.yaml \
  -f docs/dev-overrides/haproxy-testing.yaml;
  ```

This will deploy the following apps for testing (while disabling non-essential apps):

- Istio, Istio operator and Authservice
- Jaeger and Monitoring (specifically, Prometheus), with SSO enabled
- HAProxy

## Validation/Testing Steps

1. Once deployment is complete, verify that the pod `authservice-haproxy-sso-*` in the `authservice` namespace is ready.
1. Navigate to [Jaeger](https://tracing.dev.bigbang.mil/) and validate that you are prompted to login with SSO and that the login is successful.
1. Navigate to [Prometheus](https://prometheus.dev.bigbang.mil) and validate that you are prompted to login with SSO and that the login is successful.

### OPTIONAL: If you'd like to test further you can spin up a local sso workflow and test it to get to prometheus using haproxy

1. Ensure that authservice came up and that there is an haproxy pod in the authservice namespace as above
1. Ensure that there are authorization policies in the authservice namespace
1. Navigate to [Prometheus](https://prometheus.dev.bigbang.mil) and validate that you are prompted to login with SSO and that the login is successful.
1. Navigate to [Jaeger](https://tracing.dev.bigbang.mil) and validate that you are prompted to login with SSO and that the login is successful.
1. Delete all of the authorization policies in the authservice namespace, except the default deny - you should start getting 403/503 on [Prometheus](https://prometheus.dev.bigbang.mil) and [Jaeger](https://tracing.dev.bigbang.mil) depending on prometheus' state
1. Delete all of the authorization policies in the authservice namespace, both [Prometheus](https://prometheus.dev.bigbang.mil) and [Jaeger](https://tracing.dev.bigbang.mil) should redirect to an SSO page to login *Note: This will only work for a small amount of time until the authorization policies are automatically created again.*

See also: [instructions for authservice](https://repo1.dso.mil/big-bang/product/packages/authservice/-/blob/main/docs/DEVELOPMENT_MAINTENANCE.md) and [suggested haproxy-sso-workflow test](https://repo1.dso.mil/big-bang/product/packages/authservice/-/merge_requests/135#note_1761311).

## Files That Require Integration Testing

- ./chart/templates/bigbang/istio/authorizationPolicies/allow-intranamespace.yaml
- ./chart/templates/bigbang/istio/authorizationPolicies/template.yaml

### Instructions for Integration Testing

See the [Big Bang Doc](https://repo1.dso.mil/big-bang/bigbang/-/blob/master/docs/developer/test-package-against-bb.md?ref_type=heads)

# Modifications made to upstream chart
This is a high-level list of modifications that Big Bang has made to the upstream helm chart. You can use this as as cross-check to make sure that no modifications were lost during the upgrade process.

##  chart/Chart.yaml
- Append `-bb.0` to `.version`.
- Update the `.appVersion` to the value that you find for `.image.tag` in `chart/values.yaml`
- Add the `annotations."bigbang.dev/applicationVersions"` as described above.

##  chart/values.yaml
- After the license add the `BigBang additions` back.
    ```yaml
    ## BigBang additions:
    imagePullSecrets:
    - name: private-registry
    usePSP: false
    ```
- Switch the `.image.repository` back to the registry1 upstream.
    ```yaml
      repository: registry1.dso.mil/ironbank/opensource/haproxy/haproxy22    # can be changed to use CE or EE images
    ```
- Switch the `.image.tag` to the latest version on [ironbank](https://registry1.dso.mil/harbor/projects/3/repositories/opensource%2Fhaproxy%2Fhaproxy22/artifacts-tab).
- Update the `.existingImagePullSecret` to `private-registry`.
- Merge this in.
    ```yaml
    podSecurityPolicy:
      create: false
    ```
- Update the `.securityContext` [to fix non-root user and group so it could pass kyverno](https://repo1.dso.mil/big-bang/product/packages/haproxy/-/merge_requests/25#note_1772079).
    ```yaml
    securityContext:
      enabled: true
      capabilities:
        drop:
          - ALL
      fsGroup: 1111
      fsGroupChangePolicy: OnRootMismatch
      runAsUser: 1111
      runAsGroup: 1111
      runAsNonRoot: true
    ```
- Update the `.resources`
    ```yaml
    resources:
      limits:
        cpu: 100m
        memory: 500Mi
      requests:
        cpu: 100m
        memory: 500Mi
    ```

## chart/templates/daemonset.yaml
- Added call to `bigbang.labels` helper function under `spec.template.metadata.labels`
    ```
    {{- include "bigbang.labels" . | nindent 8 }}
    ```

## chart/templates/deployment.yaml
- Added call to `bigbang.labels` helper function under `spec.template.metadata.labels`
    ```
    {{- include "bigbang.labels" . | nindent 8 }}
    ```

### automountServiceAccountToken
The mutating Kyverno policy named `update-automountserviceaccounttokens` is leveraged to harden all ServiceAccounts in this package with `automountServiceAccountToken: false`. This policy is configured by namespace in the Big Bang umbrella chart repository at [chart/templates/kyverno-policies/values.yaml](https://repo1.dso.mil/big-bang/bigbang/-/blob/master/chart/templates/kyverno-policies/values.yaml?ref_type=heads).

This policy revokes access to the K8s API for Pods utilizing said ServiceAccounts. If a Pod truly requires access to the K8s API (for app functionality), the Pod is added to the `pods:` array of the same mutating policy. This grants the Pod access to the API, and creates a Kyverno PolicyException to prevent an alert.

