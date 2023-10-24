# How to upgrade the HAProxy Package chart

BigBang makes modifications to the upstream helm chart. The full list of changes is at the end of  this document.

---

1. Find the current and latest release notes from the [release page](https://github.com/haproxytech/helm-charts/releases?q=haproxy-1&expanded=true). Be aware of changes that are included in the upgrade. Take note of any manual upgrade steps that customers might need to perform, if any.
1. Do diff of [upstream chart](https://github.com/haproxytech/helm-charts/tree/main/haproxy) between old and new release tags to become aware of any significant chart changes. A graphical diff tool such as [Meld](https://meldmerge.org/) is useful. You can see where the current helm chart came from by inspecting `/chart/kptfile` or for an easier way to see the changes skip forward to the KPT instructions.
1. Create a development branch and merge request from the Gitlab issue.
1. Merge/Sync the new helm chart with the existing HAProxy package code. A graphical diff tool like [Meld](https://meldmerge.org/) is useful. Reference the "Modifications made to upstream chart" section below.
    1. An easy way to do this is with KPT
    1. In `chart/Kptfile` update `.upstream.git.ref` to the tag of the release you found earlier.
    1. Run the following.
        ```bash
        kpt pkg update chart --strategy force-delete-replace
        ```
1. Do the modifications found below.
1. Update /CHANGELOG.md with an entry for "upgrade HAProxy to app version X.X.X chart version X.X.X-bb.X". Or, whatever description is appropriate.
1. Update the /README.md following the [gluon library script](https://repo1.dso.mil/platform-one/big-bang/apps/library-charts/gluon/-/blob/master/docs/bb-package-readme.md)
1. Update /chart/Chart.yaml to the appropriate versions. The annotation version should match the `appVersion` (you will likely need to change that in the modifications below).
    ```yaml
    version: X.X.X-bb.X
    appVersion: X.X.X
    annotations:
      bigbang.dev/applicationVersions: |
        - HAProxy: vX.X.X
    ```
1. Use a development environment to deploy and test HAProxy. See more detailed testing instructions below. Also test an upgrade by deploying the old version first and then deploying the new version.
1. When the Package pipeline runs expect the cypress tests to fail due to UI changes.
1. Update the /README.md again if you have made any additional changes during the upgrade/testing process.


# Testing a new HAProxy version

1. Create a k8s dev environment. One option is to use the Big Bang [k3d-dev.sh](https://repo1.dso.mil/platform-one/big-bang/bigbang/-/tree/master/docs/developer/scripts) with no arguments which will give you the default configuration. The following steps assume you are using the script.
1. Follow the instructions at the end of the script to connect to the k8s cluster and install flux.
1. Deploy HAProxy with these dev values overrides. Core apps are disabled for quick deployment.
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
1. Ensure that the pod `authservice-haproxy-sso-*` comes up.
1. Browse to `prometheus.bigbang.dev`.
1. You should get redirected to an SSO page.

Note: if you'd like to test further you can use the [instructions for authservice](https://repo1.dso.mil/big-bang/product/packages/authservice/-/blob/main/docs/DEVELOPMENT_MAINTENANCE.md) to spin up a local sso workflow and test it to get to prometheus using haproxy.

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
- Update the `.securityContext`
    ```yaml
    securityContext:
      enabled: false
      runAsUser: 1000
      runAsGroup: 1000
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
