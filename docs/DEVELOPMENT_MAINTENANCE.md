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


# Testing a new HAProxy version

1. Create a k8s dev environment. One option is to use the Big Bang [k3d-dev.sh](https://repo1.dso.mil/big-bang/bigbang/-/blob/master/docs/assets/scripts/developer/k3d-dev.sh) with no arguments which will give you the default configuration. The following steps assume you are using the `dev` script in this fashion.
1. Connect to the k8s cluster and [./install_flux.sh](https://repo1.dso.mil/big-bang/bigbang/-/blob/master/scripts/install_flux.sh)
1. Deploy HAProxy with these minimal values overrides; core apps are disabled for quick deployment.
    ```yaml
    istio:
      enabled: true

    monitoring:
      enabled: true
      sso:
        enabled: true
      istio:
        injection: "disabled"
    ```
1. Once deployment is complete, verify that the pod `authservice-haproxy-sso-*` is ready.
1. Browse to [http://prometheus.dev.bigbang.mil](http://prometheus.dev.bigbang.mil)
1. You should get redirected to an SSO page.

### OPTIONAL: If you'd like to test further you can spin up a local sso workflow and test it to get to prometheus using haproxy  
1. BB Integration Test; deploy with the below values:
1. Ensure that authservice came up and that there is an haproxy pod in the authservice namespace
1. Ensure that there are authorization policies in the authservice namespace
1. Navigate to [http://prometheus.dev.bigbang.mil](http://prometheus.dev.bigbang.mil) and you should get pulled to an SSO page to login
1. Delete all of the authorization policies in the authservice namespace, except the default deny - you should start getting 403/503 on prometheus.dev.bigbang.mi depending on prometheus' state
```yaml
istio:
  enabled: true

monitoring:
  enabled: true
  sso:
    enabled: true
  istio:
    injection: "disabled"

addons:
  haproxy:
    git:
      tag: null
      branch: "15-implement-istio-authorization-policies"
    values:
      istio:
        enabled: true
        hardened:
          enabled: true
  authservice:
    git:
      tag: null
      branch: "81-implement-istio-authorization-policies"
    values:
      istio:
        enabled: true
        hardened:
          enabled: true


```
See also: [instructions for authservice](https://repo1.dso.mil/big-bang/product/packages/authservice/-/blob/main/docs/DEVELOPMENT_MAINTENANCE.md) and [suggested haproxy-sso-workflow test](https://repo1.dso.mil/big-bang/product/packages/authservice/-/merge_requests/135#note_1761311).

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

### automountServiceAccountToken
The mutating Kyverno policy named `update-automountserviceaccounttokens` is leveraged to harden all ServiceAccounts in this package with `automountServiceAccountToken: false`. This policy is configured by namespace in the Big Bang umbrella chart repository at [chart/templates/kyverno-policies/values.yaml](https://repo1.dso.mil/big-bang/bigbang/-/blob/master/chart/templates/kyverno-policies/values.yaml?ref_type=heads). 

This policy revokes access to the K8s API for Pods utilizing said ServiceAccounts. If a Pod truly requires access to the K8s API (for app functionality), the Pod is added to the `pods:` array of the same mutating policy. This grants the Pod access to the API, and creates a Kyverno PolicyException to prevent an alert.

