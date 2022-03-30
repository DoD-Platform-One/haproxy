# haproxy

![Version: 1.12.0-bb.0](https://img.shields.io/badge/Version-1.12.0--bb.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.2.21](https://img.shields.io/badge/AppVersion-2.2.21-informational?style=flat-square)

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

https://helm.sh/docs/intro/install/

## Deployment

* Clone down the repository
* cd into directory
```bash
helm install haproxy chart/
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| imagePullSecrets[0].name | string | `"private-registry"` |  |
| usePSP | bool | `false` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `nil` |  |
| image.repository | string | `"registry1.dso.mil/ironbank/opensource/haproxy/haproxy22"` |  |
| image.tag | string | `"v2.2.21"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| checksumConfigMap.enabled | bool | `true` |  |
| shareProcessNamespace.enabled | bool | `false` |  |
| sidecarContainers | list | `[]` |  |
| kind | string | `"Deployment"` |  |
| replicaCount | int | `1` |  |
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
| extraVolumeMounts | list | `[]` |  |
| extraVolumes | list | `[]` |  |
| config | string | `"global\n  log stdout format raw local0\n  maxconn 1024\n\ndefaults\n  log global\n  timeout client 60s\n  timeout connect 60s\n  timeout server 60s\n\nfrontend fe_main\n  bind :80\n  default_backend be_main\n\nbackend be_main\n  server web1 10.0.0.1:8080 check\n"` |  |
| includes | string | `nil` |  |
| includesMountPath | string | `"/etc/haproxy"` |  |
| mountedSecrets | list | `[]` |  |
| nodeSelector | object | `{}` |  |
| tolerations | list | `[]` |  |
| affinity | object | `{}` |  |
| topologySpreadConstraints | list | `[]` |  |
| dnsConfig | object | `{}` |  |
| dnsPolicy | string | `"ClusterFirst"` |  |
| podLabels | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podSecurityPolicy.create | bool | `false` |  |
| podSecurityContext | object | `{}` |  |
| securityContext.enabled | bool | `false` |  |
| securityContext.runAsUser | int | `1000` |  |
| securityContext.runAsGroup | int | `1000` |  |
| resources.limits.cpu | string | `"100m"` |  |
| resources.limits.memory | string | `"500Mi"` |  |
| resources.requests.cpu | string | `"100m"` |  |
| resources.requests.memory | string | `"500Mi"` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.maxReplicas | int | `7` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| PodDisruptionBudget.enable | bool | `false` |  |
| service.type | string | `"ClusterIP"` |  |
| service.clusterIP | string | `""` |  |
| service.loadBalancerIP | string | `""` |  |
| service.loadBalancerSourceRanges | list | `[]` |  |
| service.externalIPs | list | `[]` |  |
| service.annotations | object | `{}` |  |
| serviceMonitor.enabled | bool | `false` |  |
| serviceMonitor.extraLabels | object | `{}` |  |
| serviceMonitor.endpoints[0].port | string | `"prometheus"` |  |
| serviceMonitor.endpoints[0].path | string | `"/metrics"` |  |
| serviceMonitor.endpoints[0].scheme | string | `"http"` |  |
| ingress.enabled | bool | `false` |  |
| ingress.servicePort | int | `80` |  |
| ingress.className | string | `""` |  |
| ingress.labels | object | `{}` |  |
| ingress.annotations | object | `{}` |  |
| ingress.hosts[0].host | string | `"haproxy.domain.com"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |

## Contributing

Please see the [contributing guide](./CONTRIBUTING.md) if you are interested in contributing.
