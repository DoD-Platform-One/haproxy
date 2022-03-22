# haproxy

![Version: 1.1.2-bb.4](https://img.shields.io/badge/Version-1.1.2--bb.4-informational?style=flat-square) ![AppVersion: 2.2.21](https://img.shields.io/badge/AppVersion-2.2.21-informational?style=flat-square)

A Helm chart for HAProxy on Kubernetes

## Upstream References
* <https://github.com/haproxytech/helm-charts/tree/master/haproxy>

* <http://www.haproxy.org/>

## Learn More
* [Application Overview](docs/overview.md)
* [Other Documentation](docs/)

## Pre-Requisites

* Kubernetes Cluster deployed
* Kubernetes config installed in `~/.kube/config`
* Helm installed

Kubernetes: `>=1.12.0-0`

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
| kind | string | `"Deployment"` |  |
| replicaCount | int | `1` |  |
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
| containerPorts.http | int | `80` |  |
| containerPorts.https | int | `443` |  |
| containerPorts.stat | int | `1024` |  |
| strategy | object | `{}` |  |
| priorityClassName | string | `""` |  |
| config | string | `"global\n  log stdout format raw local0\n  maxconn 1024\n\ndefaults\n  log global\n  timeout client 60s\n  timeout connect 60s\n  timeout server 60s\n\nfrontend fe_main\n  bind :80\n  default_backend be_main\n\nbackend be_main\n  server web1 10.0.0.1:8080 check\n"` |  |
| nodeSelector | object | `{}` |  |
| tolerations | list | `[]` |  |
| affinity | object | `{}` |  |
| dnsConfig | object | `{}` |  |
| dnsPolicy | string | `"ClusterFirst"` |  |
| podLabels | object | `{}` |  |
| podAnnotations | object | `{}` |  |
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
| service.type | string | `"ClusterIP"` |  |
| service.clusterIP | string | `""` |  |
| service.loadBalancerIP | string | `""` |  |
| service.loadBalancerSourceRanges | list | `[]` |  |
| service.annotations | object | `{}` |  |

## Contributing

Please see the [contributing guide](./CONTRIBUTING.md) if you are interested in contributing.
