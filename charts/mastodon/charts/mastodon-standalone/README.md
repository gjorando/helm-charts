# Mastodon standalone Helm Chart

[Mastodon](https://github.com/mastodon/mastodon) is a free, open-source social network server based on ActivityPub where users can follow friends and discover new ones. This [Helm](https://helm.sh) chart deploys a barebone mastodon instance, without any of the required dependencies (Redis, database...). If you want a fully featured chart, see the [fully featured mastodon chart](../../README.md).

## Prerequisites

- Kubernetes >=1.30
- TODO (PV provisioner, helm version, etc.)

## Installing/uninstalling the chart

You will need to configure the chart values to fit your needs, especially regarding the dependencies (database, Redis...). See the [documentation](#configuration) below. Once this is done, add the repository and install the standalone chart.

```
# Namespace for the release
NAMESPACE=mastodon
# Add the repository to Helm
help repo add mastodon https://gjorando.github.io/helm-charts
# Install mastodon in the desired namespace
helm upgrade --install my-mastodon mastodon/mastodon-standalone -n $NAMESPACE --create-namespace --values my-values.yaml
```

## Configuration

The following table lists the configurable parameters and their default values.

Your `values.yaml` file should at the bare minimum define the keys that are outlined in **bold**. Moreover, check thouroughly the keys that are outlined in _italic_, as they may refer to important configuration. You can find more information on the [Mastodon documentation](https://docs.joinmastodon.org/admin/config/).

**Important note:** secrets are not recreated if they already exist. This ensures that they're not re-generated. Moreover, they're not deleted automatically when the release is uninstalled.

### General

| Parameter  | Description | Default |
|---|---|---|
| `image` | Image parameters for the pods. Set `image.pullPolicy` to `Always` if you plan on using `latest` for `image.tag`. If the tag is not set, the chart `appVersion` attribute is used instead. `image.repository` changes the link from whence the image is pulled. | See [`values.yaml`](values.yaml) |
| `imagePullSecrets` | Secrets list for pulling the image from a private registry. | Empty |
| `nameOverride` | Overrides the name of the chart. | Empty (the default chart name is used) |
| `fullnameOverride` | Overrides the fully qualified app name | Empty (the chart name is used, if it doesn't contain the release name, it is prefixed) |
| `serviceAccount` | Configuration map for the service account. It is created if `serviceAccount.create` is `true`. If you want to use an existing service account, please specify its name using `serviceAccount.name`. | See [`values.yaml`](values.yaml) |
| `podAnnotations` | Custom annotations to add to the deployed pods. | Empty |
| `podLabels` | Custom labels to add to the deployed pods. | Empty |
| `commonLabels` | Custom labels to add to all deployed objects. | Empty |
| `podSecurityContext` | Security context for the deployed pods. | Empty |
| `securityContext` | Security context for the pods' containers. | Empty |
| `services` | Services configuration for Mastodon. Two keys are available, `web` and `streaming`. | `ClusterIP`, on port 3000 for `web` and port 4000 for `streaming` |
| `resources` | Resources to allocate to the containers. | Empty |
| `nodeSelector` | Node selector for the deployments. | Empty |
| `tolerations` | Tolerations list for the deployments. | Empty |
| `affinity` | Affinities for the deployments. | Empty |

### Mastodon

| Parameter  | Description | Default |
|---|---|---|
| **`localDomain`** | Domain name (without the protocol part) of your instance. It is used as a unique identifier on the Fediverse, and cannot be changed once your instance is created. | REQUIRED |
| _`existingSecret`_ | Mastodon secrets of your instance. The data keys refer to the environment variables in a `env.production` file. See [`secret.yaml`](templates/secret.yaml) for the full list of secrets. | Unset (a new secret is created with generated random values) |

### Redis

| Parameter  | Description | Default |
|---|---|---|
| **`redis.host`** | Host for the Redis instance. | Required |
| `redis.port` | Port for the Redis instance. | `6379` |
| _`redis.secretKeyRef`_ | A Kubernetes [`SecretKeySelector`](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#environment-variables-1) referring to the secret key that stores the Redis password. | Unset (connection is made without a password) |

### PostgreSQL

| Parameter  | Description | Default |
|---|---|---|
| **`postgres.host`** | Host for the PostgreSQL instance. | Required |
| `postgres.port` | Port for the PostgreSQL instance. | `5432` |
| **`postgres.name`** | Name of the PostgreSQL db. | Required |
| `postgres.user` | Name of the PostgreSQL user. | `mastodon` |
| _`postgres.secretKeyRef`_ | A Kubernetes [`SecretKeySelector`](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#environment-variables-1) referring to the secret key that stores the user password. | Unset (connection is made without a password) |

### SMTP

| Parameter  | Description | Default |
|---|---|---|
| `smtp.enabled` | Enable SMTP configuration for e-mail notifications. | `true` |
| **`smtp.host`** | SMTP server address. | Required if `smtp.enabled` is `true` |
| `smtp.port` | SMTP port. | `587` |
| `smtp.fromAddress` | Address for the from field of e-mails. | Unset (use `notification@<localDomain>`) |
| **`smtp.user`** | Login credential for the SMTP server. | Required if `smtp.enabled` is `true` |
| **`smtp.secretKeyRef`** | A Kubernetes [`SecretKeySelector`](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#environment-variables-1) referring to the secret key that stores the SMTP password. | Required if `smtp.enabled` is `true` |

### Networking

For now, only the Gateway API is supported. No `Gateway` object is deployed, it must instead be refered in the appropriate configuration parameter.

| Parameter  | Description | Default |
|---|---|---|
| `networking.enabled`| Enable the deployment of networking objects for ingress traffic. | `true` |
| _`networking.type`_ | Whether to use the classic [Ingress API](https://kubernetes.io/docs/concepts/services-networking/ingress/) (TODO not supported yet, `ingress`) or the modern [Gateway API](https://kubernetes.io/docs/concepts/services-networking/gateway/) (`gateway`). | `gateway` |
| **`networking.gateway.parentRefs`** | A Gateway API [`ParentReference`](https://gateway-api.sigs.k8s.io/reference/spec/#gateway.networking.k8s.io/v1.ParentReference) mapping referencing the Gateway to use for the routes. | Required if `networking.type` is `gateway` |

### Storage

If persistence is enabled, the following volumes can be defined:
- `assets`: `<mastodon_root_folder>/public/assets`
- `system`: `<mastodon_root_folder>/public/system`

| Parameter  | Description | Default |
|---|---|---|
| `persistence.enabled` | Whether to enable persistence of app data | `true` |
| `persistence.existingClaims` | Use existing claims instead of having them created by Helm. Each key is a volume, mapping to the name of the existing claim. | Empty |
| `persistence.accessMode` | Access mode for the claims. | `ReadWriteOnce` |
| `persistence.storageClassName` | Storage class name to require. | Unset (default storage class for the cluster is used) |
| `persistence.resources` | Resources requirements for each claim. Each key is a volume, mapping to a Kubernetes [`VolumeResourceRequirements`](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#resources) mapping. | 10GiB for `assets`, 100GiB for `system` | 
| `volumes` | List of additonal volumes on the deployed pods. | Empty |
| `volumeMounts` | List of additional mounts on the deployed pods. | Empty |

## Usage

See the [fully featured mastodon chart documentation](../../README.md) for more details.
