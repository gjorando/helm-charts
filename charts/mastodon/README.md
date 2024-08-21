# Mastodon Helm Chart

[Mastodon](https://github.com/mastodon/mastodon) is a free, open-source social network server based on ActivityPub where users can follow friends and discover new ones. This is an easy-to-use, modular [Helm](https://helm.sh) chart that bootstraps the deployment process of a fully-featured Mastodon instance on Kubernetes.

## Prerequisites

- Kubernetes >=1.30
- TODO (PV provisioner, helm version, etc.)

## Installation and Uninstallation

The most straightforward way of setting up a Mastodon instance is to add the repository to Helm, and install the main chart `mastodon`.

```
# Namespace for the release
NAMESPACE=mastodon
# Add the repository to Helm
help repo add mastodon https://gjorando.github.io/helm-charts
# Install mastodon in the desired namespace
helm upgrade --install my-mastodon mastodon/mastodon -n $NAMESPACE --create-namespace
```

Alternatively, although this is not recommended, you can clone the [GitHub repository](https://github.com/gjorando/helm-charts) and install the local cloned chart.

```
NAMESPACE=mastodon
git clone git@github.com:gjorando/helm-charts.git
helm upgrade --install my-mastodon helm-charts/charts/mastodon -n $NAMESPACE --create-namespace
```

If you're working with local or unprovisioned storage, you will need to create the persistent volumes yourself.

## Configuration

The following table lists the configurable parameters and their default values.

| Parameter  | Description | Default |
|---|---|---|
| `commonLabels` |List of additional custom labels that will be applied to every object deployed by the chart (excluding optional dependencies). | `null`  |
| `name` | Name for the mastodon instance. | Helm release  |
| `tags.pgo` | Whether to enable [PGO](#pgo). | `true`  |
| `tags.postgrescluster` | Whether to deploy a [Postgres cluster](#pgo). | `true`  |

The following sections list all the optional dependencies and the value overrides we set.

### PGO

[PGO](https://github.com/CrunchyData/postgres-operator) is the operator for [Crunchy Postgres](https://www.crunchydata.com/products/crunchy-postgresql-for-kubernetes), a Kubernetes native Postgres solution. The default installation deploys the operator in the installation namespace and setups a Crunchy Postgres instance (see [Crunchy postgres configuration](#postgres) for details on configuring the Postgres deployment itself).

If you already have a PGO deployment that isn't tied to a namespace, you may want to disable this dependency entirely by setting `tags.pgo` to `false`.

You should read the [PGO documentation](https://access.crunchydata.com/documentation/postgres-operator/latest/installation/helm) for details regarding the values configuration. The following table lists our own configuration overrides for the `pgo` dependency.

| Overridden value | Reason | Override |
|---|---|---|
| `debug` | Disable debug logging. | `false` |
| `singleNamespace` | PGO only watches for the PostgreSQL clusters deployed in the installation namespace.   | `true` |

### Postgres cluster

This is an installation of [Crunchy Postgres for Kubernetes](https://access.crunchydata.com/documentation/postgres-operator/latest), a declarative Postgres solution for Kubernetes. It leverages PGO (see [above](#pgo)), an operator that orchestrates the life cycle of a scalable PostgreSQL solution.

You should read the [documentation](https://access.crunchydata.com/documentation/postgres-operator/latest/tutorials/basic-setup/create-cluster) for detailed instructions on using PGO and its custom CRDs. You can also read the [dependency chart's `values.yaml`](charts/postgrescluster/values.yaml), which contains details for each configuration key.

The following table lists our configuration overrides for the `postgrescluster` dependency.

| Overridden value | Reason | Override |
|---|---|---|
| `databaseInitSQL` | Points to the config key `bootstrap.sql` from the `postgrescluster-bootstrap-config` config map. This script creates [the user schema](https://www.crunchydata.com/blog/be-ready-public-schema-changes-in-postgres-15) for the default user. The config map won't be created if it already exists. As a result, you can override this behaviour by creating a config map with the same name beforehand. Only do this if you know what you are doing. | See [`values.yaml`](values.yaml) |
| `users` | Creates a single user with the name `mastodon`, owner of the `mastodon` database. If you wish to override this behaviour, you should know that only the first user in the generated YAML will have their schema created (see databaseInitSQL`). Moreover, the first database in the generated YAML for this user will be used. You should not create multiple users, nor should you create more than one database. | See [`values.yaml`](values.yaml) |

## Usage

Cronjobs, backups, upgrades, etc.
