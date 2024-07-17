# haproxy

![Version: 1.19.3-bb.7](https://img.shields.io/badge/Version-1.19.3--bb.7-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.2.33](https://img.shields.io/badge/AppVersion-2.2.33-informational?style=flat-square)

A Helm chart for HAProxy on Kubernetes

## Upstream References

* <https://github.com/haproxytech/helm-charts/tree/main/haproxy>

* <http://www.haproxy.org/>

## Learn More

* [Application Overview](docs/overview.md)
* [Other Documentation](docs/)

## Pre-Requisites

* Kubernetes Cluster deployed
* Kubernetes config installed in `~/.kube/config`
* Helm installed

Kubernetes: `>=1.17.0-0`

Install Helm

<https://helm.sh/docs/intro/install/>

## Deployment

* Clone down the repository
* cd into directory

```bash
helm install haproxy chart/
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| openshift | bool | `false` |  |
| imagePullSecrets[0].name | string | `"private-registry"` |  |
| usePSP | bool | `false` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `nil` |  |
| image.repository | string | `"registry1.dso.mil/ironbank/opensource/haproxy/haproxy22"` |  |
| image.tag | string | `"v2.2.33"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| checksumConfigMap.enabled | bool | `true` |  |
| shareProcessNamespace.enabled | bool | `false` |  |
| sidecarContainers | list | `[]` |  |
| kind | string | `"Deployment"` |  |
| replicaCount | int | `1` |  |
| minReadySeconds | int | `0` |  |
| args.enabled | bool | `true` |  |
| args.defaults[0] | string | `"-f"` |  |
| args.defaults[1] | string | `"/usr/local/etc/haproxy/haproxy.cfg"` |  |
| args.extraArgs | list | `[]` |  |
| livenessProbe | object | `{}` |  |
| readinessProbe | object | `{}` |  |
| startupProbe | object | `{}` |  |
| daemonset.useHostNetwork | bool | `false` |  |
| daemonset.useHostPort | bool | `false` |  |
| daemonset.hostPorts.http | int | `80` |  |
| daemonset.hostPorts.https | int | `443` |  |
| daemonset.hostPorts.stat | int | `1024` |  |
| initContainers | list | `[]` |  |
| terminationGracePeriodSeconds | int | `60` |  |
| imageCredentials.registry | string | `nil` |  |
| imageCredentials.username | string | `nil` |  |
| imageCredentials.password | string | `nil` |  |
| existingImagePullSecret | string | `"private-registry"` |  |
| containerPorts.http | int | `80` |  |
| containerPorts.https | int | `443` |  |
| containerPorts.stat | int | `1024` |  |
| strategy | object | `{}` |  |
| priorityClassName | string | `""` |  |
| lifecycle | object | `{}` |  |
| extraEnvs | list | `[]` |  |
| extraVolumeMounts | list | `[]` |  |
| extraVolumes | list | `[]` |  |
| config | string | `"global\n  log stdout format raw local0\n  maxconn 1024\n\ndefaults\n  log global\n  timeout client 60s\n  timeout connect 60s\n  timeout server 60s\n\nfrontend fe_main\n  bind :80\n  default_backend be_main\n\nbackend be_main\n  server web1 10.0.0.1:8080 check\n"` |  |
| configMount.mountPath | string | `"/usr/local/etc/haproxy/haproxy.cfg"` |  |
| configMount.subPath | string | `"haproxy.cfg"` |  |
| includes | string | `nil` |  |
| includesMountPath | string | `"/usr/local/etc/haproxy/includes"` |  |
| mountedSecrets | list | `[]` |  |
| nodeSelector | object | `{}` |  |
| tolerations | list | `[]` |  |
| affinity | object | `{}` |  |
| topologySpreadConstraints | list | `[]` |  |
| dnsConfig | object | `{}` |  |
| dnsPolicy | string | `"ClusterFirst"` |  |
| podLabels | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| rbac.create | bool | `true` |  |
| podSecurityPolicy.create | bool | `false` |  |
| podSecurityPolicy.annotations | object | `{}` |  |
| podSecurityPolicy.enabled | bool | `false` |  |
| podSecurityPolicy.allowedUnsafeSysctls | string | `nil` |  |
| podSecurityContext.enabled | bool | `true` |  |
| podSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| podSecurityContext.fsGroup | int | `1111` |  |
| podSecurityContext.fsGroupChangePolicy | string | `"OnRootMismatch"` |  |
| podSecurityContext.runAsUser | int | `1111` |  |
| podSecurityContext.runAsGroup | int | `1111` |  |
| podSecurityContext.runAsNonRoot | bool | `true` |  |
| securityContext.enabled | bool | `true` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.fsGroup | int | `1111` |  |
| securityContext.fsGroupChangePolicy | string | `"OnRootMismatch"` |  |
| securityContext.runAsUser | int | `1111` |  |
| securityContext.runAsGroup | int | `1111` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| resources.limits.cpu | string | `"100m"` |  |
| resources.limits.memory | string | `"500Mi"` |  |
| resources.requests.cpu | string | `"100m"` |  |
| resources.requests.memory | string | `"500Mi"` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.maxReplicas | int | `7` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| keda.enabled | bool | `false` |  |
| keda.minReplicas | int | `2` |  |
| keda.maxReplicas | int | `20` |  |
| keda.pollingInterval | int | `30` |  |
| keda.cooldownPeriod | int | `300` |  |
| keda.restoreToOriginalReplicaCount | bool | `false` |  |
| keda.scaledObject.annotations | object | `{}` |  |
| keda.behavior | object | `{}` |  |
| keda.triggers | list | `[]` |  |
| PodDisruptionBudget.enable | bool | `false` |  |
| service.type | string | `"ClusterIP"` |  |
| service.clusterIP | string | `""` |  |
| service.loadBalancerIP | string | `""` |  |
| service.loadBalancerSourceRanges | list | `[]` |  |
| service.externalIPs | list | `[]` |  |
| service.annotations | object | `{}` |  |
| service.additionalPorts | object | `{}` |  |
| serviceMonitor.enabled | bool | `false` |  |
| serviceMonitor.extraLabels | object | `{}` |  |
| serviceMonitor.endpoints[0].port | string | `"prometheus"` |  |
| serviceMonitor.endpoints[0].path | string | `"/metrics"` |  |
| serviceMonitor.endpoints[0].scheme | string | `"http"` |  |
| serviceMonitor.endpoints[0].interval | string | `"30s"` |  |
| ingress.enabled | bool | `false` |  |
| ingress.servicePort | int | `80` |  |
| ingress.className | string | `""` |  |
| ingress.labels | object | `{}` |  |
| ingress.annotations | object | `{}` |  |
| ingress.hosts[0].host | string | `"haproxy.domain.com"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| istio.enabled | bool | `false` |  |
| istio.hardened.enabled | bool | `false` |  |
| istio.hardened.customAuthorizationPolicies | list | `[]` |  |
| istio.mtls.mode | string | `"STRICT"` |  |

## Contributing

Please see the [contributing guide](./CONTRIBUTING.md) if you are interested in contributing.
