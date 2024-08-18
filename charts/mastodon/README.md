# Mastodon Helm Chart

[Mastodon](https://github.com/mastodon/mastodon) is a free, open-source social network server based on ActivityPub where users can follow friends and discover new ones. This is an easy-to-use, modular [Helm](https://helm.sh) chart that bootstraps the deployment process of a fully-featured Mastodon instance on Kubernetes.

## Prerequisites

- Kubernetes >=1.30
- TODO (PV provisioner, helm version, etc.)

## Installation and Uninstallation

## Configuration

The following table lists the configurable parameters and their default values.

| Parameter  | Description                   | Default |
|------------|-------------------------------|---------|
| `tags.pgo` | Whether to enable [PGO](#pgo) | `true`  |

### PGO

[PGO](https://github.com/CrunchyData/postgres-operator) is the operator for [Crunchy Postgres](https://www.crunchydata.com/products/crunchy-postgresql-for-kubernetes), a Kubernetes native Postgres solution. The default installation deploys the operator in the installation namespace and setups a Crunchy Postgres instance (see [Crunchy postgres configuration](#postgres) for details on configuring the Postgres deployment itself).

If you already have a PGO deployment that isn't tied to a namespace, you may want to disable this dependency entirely by setting `tags.pgo` to `false`.

You should read the [PGO documentation](https://access.crunchydata.com/documentation/postgres-operator/latest/installation/helm) for details regarding the values configuration. The following table lists our own configuration overrides.

| Overridden value | Reason | Override |
|---|---|---|
| `pgo.singleNamespace` | PGO only watches for the PostgreSQL clusters deployed in the installation namespace   | `true` |
| `pgo.debug` | Disable debug logging | `false` |

### Postgres cluster

This is an installation of [Crunchy Postgres for Kubernetes](https://access.crunchydata.com/documentation/postgres-operator/latest), a declarative Postgres solution for Kubernetes. It leverages PGO (see [above](#pgo)), an operator that orchestrates the life cycle of a scalable PostgreSQL solution.

You should read the [documentation](https://access.crunchydata.com/documentation/postgres-operator/latest/tutorials/basic-setup/create-cluster) for detailed instructions on using PGO and its custom CRDs. The following table lists our configuration overrides

| Overridden value | Reason | Override |
|---|---|---|
|  ||

## Usage

Cronjobs, backups, upgrades, etc.
