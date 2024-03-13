# Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---
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
