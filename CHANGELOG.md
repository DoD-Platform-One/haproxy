# Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---
## [1.19.3-bb.11] - 2025-09-30

### Updated

- updated image to 2.4.28
- updated registry to `registry1.dso.mil/ironbank/opensource/haproxy/haproxy24`

## [1.19.3-bb.10] - 2025-02-03

### Updated

- Added the image to the Chart.yaml under `.annotations.helm.sh/images`
- Updated `renovate.json` to point to the `2.4` version in `registry1.dso.mil`

## [1.19.3-bb.9] - 2024-11-26

### Updated

- Added the maintenance track annotation and badge

## [1.19.3-bb.8] - 2024-08-26

### Updated

- Removed previous kiali label epic changes and updated to new pattern

## [1.19.3-bb.7] - 2024-07-17

### Added

- Added `bigbang.labels` helper function to postgresql subchart under `templates/bigbang`
- Added call to `bigbang.labels` helper function in `chart/templates/deployment.yaml` and `chart/templates/daemonset.yaml` under `spec.template.metadata.labels`

## [1.19.3-bb.6] - 2024-06-21

### Changed

- Removed shared authorization policies

## [1.19.3-bb.5] - 2024-05-06

### Added

- Updated HAProxy `v2.2.32` -> `v2.2.33`
- Remove `SKIP UPDATE CHECK` prefix

## [1.19.3-bb.4] - 2024-03-05

### Added

- Added Openshift update for deploying haproxy into Openshift cluster

## [1.19.3-bb.3] - 2024-01-12

### Added

- enable istio hardening during tests

## [1.19.3-bb.2]

### Updated

- Updated HAProxy `v2.2.31` -> `v2.2.32`

## [1.19.3-bb.1] - 2023-12-22

### Added

- support for istio authorization policies and hardening

## [1.19.3-bb.0]

### Updated

- Updated chart version `1.12.0` -> `1.19.3`
- Updated HAProxy `v2.2.21` -> `v2.2.31`
- Added a `DEVELOPMENT_MAINTENANCE.md`

## [1.12.0-bb.1]

### Changed

- Updated git URLs within `tests\dependencies.yaml`

## [1.12.0-bb.0]

### Changed

- Upgrade image to version 2.2.21, update `appVersion` in Chart.yaml to 2.2.21

## [1.1.2-bb.3]

### Changed

- Update Chart.yaml to follow new standardization for release automation
- Added renovate check to update new standardization

## [1.1.2-bb.2]

### Changed

- Removed unnecessary virtual service

## [1.1.2-bb.1]

### Changed

- Added Requests and Limits
