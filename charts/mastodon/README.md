# Mastodon Helm Chart

[Mastodon](https://github.com/mastodon/mastodon) is a free, open-source social network server based on ActivityPub where users can follow friends and discover new ones. This is an easy-to-use, modular [Helm](https://helm.sh) chart that bootstraps the deployment process of a fully-featured Mastodon instance on Kubernetes.

## Prerequisites

- Kubernetes >=1.30
- TODO (PV provisioner, helm version, etc.)

## Installing/uninstalling the chart

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
| `commonLabels` | List of additional custom labels that will be applied to every object deployed by the chart (excluding optional dependencies). | `null`  |
| `tags.pgo` | Whether to enable [PGO](#pgo). | `true`  |

The following sections list all the optional dependencies and the value overrides we set.

### Mastodon standalone

This subchart deploys the actual Mastodon instance. Check [its documentation](charts/mastodon-standalone/README.md) for more details about configuring the chart.

### Postgres with PGO

[PGO](https://github.com/CrunchyData/postgres-operator) is the operator for [Crunchy Postgres](https://www.crunchydata.com/products/crunchy-postgresql-for-kubernetes), a Kubernetes native Postgres solution. The default installation deploys the operator in the release namespace and setups a Crunchy Postgres instance.

If you want to disable PGO entirely and provide your own Postgres deployment, set `tags.pgo`to `false`. You may additionally use `pgo.enabled` and `postgrescluster.enabled` to manually enable the deployment of the operator or the cluster only. The table below explains the different configurations.


| `tags.pgo` | `pgo.enabled` | `postgrescluster.enabled` | Result |
|---|---|---|
| `true` | `true` | `true` | `pgo` and `postgrescluster` installed (default, it is not required to set the `enabled` here) |
| `true` | `true` | `false` | `pgo` installed |
| `true` | `false` | `true` | `postgrescluster` installed |
| `true` | `false` | `false` | None installed (set `tags.pgo` to `false` and nothing else instead) |
| `false` | `true` | `true` | `pgo` and `postgrescluster` installed (set `tags.pgo` to `true` and nothing else instead) |
| `false` | `true` | `false` | `pgo` installed |
| `false` | `false` | `true` | `postgrescluster` installed |
| `false` | `false` | `false` | None installed (it is not required to set the `enabled` flags here)  |

#### PGO

If you already provision your own PGO deployment and want it to monitor the Postgres cluster deployed by this chart, you may want to disable this dependency entirely by setting `tags.pgo` to `false`. If doing so, check that this PGO deployment is in the release namespace, or deploy it with `singleNamespace` set to `false` (default value for their [official chart](https://github.com/CrunchyData/postgres-operator-examples/tree/main/helm/install)).

You should read the [PGO documentation](https://access.crunchydata.com/documentation/postgres-operator/latest/installation/helm) for details regarding the values configuration. The following table lists our own configuration overrides for the `pgo` dependency.

| Overridden value | Reason | Override |
|---|---|---|
| `debug` | Disable debug logging. | `false` |
| `singleNamespace` | PGO only watches for the PostgreSQL clusters deployed in the installation namespace.   | `true` |

#### PGO cluster

This is an installation of [Crunchy Postgres for Kubernetes](https://access.crunchydata.com/documentation/postgres-operator/latest), a declarative Postgres solution for Kubernetes. It leverages PGO (see [above](#pgo)), an operator that orchestrates the life cycle of a scalable PostgreSQL solution.

You should read the [documentation](https://access.crunchydata.com/documentation/postgres-operator/latest/tutorials/basic-setup/create-cluster) for detailed instructions on using PGO and its custom CRDs. You can also read the [dependency chart's `values.yaml`](charts/postgrescluster/values.yaml), which contains details for each configuration key.

The following table lists our configuration overrides for the `postgrescluster` dependency.

| Overridden value | Reason | Override |
|---|---|---|
| `databaseInitSQL` | Point to the config key `bootstrap.sql` from the `postgrescluster-bootstrap-config` config map. This script creates [the user schema](https://www.crunchydata.com/blog/be-ready-public-schema-changes-in-postgres-15) for the default user. The config map won't be created if it already exists. As a result, you can override this behaviour by creating a config map with the same name beforehand. Only do this if you know what you are doing. | See [`values.yaml`](values.yaml) |
| `users` | Create a single user with the name `mastodon`, owner of the `mastodon` database. If you wish to override this behaviour, you should know that only the first user in the generated YAML will have their schema created (see databaseInitSQL`). Moreover, the first database in the generated YAML for this user will be used. You should not create multiple users, nor should you create more than one database. | See [`values.yaml`](values.yaml) |

### Redis

Mastodon uses Redis for transient key value storage. The default installation deploys a single Redis instance to use for your Mastodon installation. You should read the [Redis chart documentation](https://artifacthub.io/packages/helm/bitnami/redis), which details its setup and customization. If you want to provision your own Redis instance, disable the subchart by setting `redis.enabled` to `false`.

By default, this chart installs a secret storing the redis instance password. It won't be deleted when the chart is uninstalled.

The following table lists our configuration overrides for the `redis` dependency.

| Overridden value | Reason | Override |
|---|---|---|
| `auth` | Enable password authentication through the config key `redis-password` from the `redis-secret` secret. The secret won't be created if it already exists. As a result, you can override this behaviour by creating a secret with the same name beforehand. Only do this if you know what you are doing. | See [`values.yaml`](values.yaml) |
| `architecture` | With the `standalone` value, a simple single service Redis instance is deployed. While this may be fine for small instances, you may want to change this to `replication` to deploy a replicas service, which exposes Redis replicas (see [documentation](https://artifacthub.io/packages/helm/bitnami/redis#cluster-topologies)). | `standalone` |

## Usage

Cronjobs, backups, upgrades, etc.
