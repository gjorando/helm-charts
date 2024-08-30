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

### General parameters

| Parameter  | Description | Default |
|---|---|---|
| `image` | Image parameters for the pods. Set `image.pullPolicy` to `Always` if you plan on using `latest` for `image.tag`. If the tag is not set, the chart `appVersion` attribute is used instead. `image.repository` changes the link from whence the image is pulled. | See [`values.yaml`](values.yaml) |
| `imagePullSecrets` | Secrets list for pulling the image from a private registry. | Empty |
| `nameOverride` | Overrides the name of the chart. | Empty (the default chart name is used) |
| `fullnameOverride` | Overrides the fully qualified app name | Empty (the chart name is used, if it doesn't contain the release name, it is prefixed) |
| `serviceAccount` | Configuration map for the service account. It is created if `serviceAccount.create` is `true`. | See [`values.yaml`](values.yaml) |
| `podAnnotations` | Custom annotations to add to the deployed pods. | Empty |
| `podLabels` | Custom labels to add to the deployed pods. | Empty |
| `commonLabels` | Custom labels to add to all deployed objects. | Empty |
| `podSecurityContext` | Security context for the deployed pods. | Empty |
| `securityContext` | Security context for the pods' containers. | Empty |
| `services` | Services configuration for Mastodon. Two keys are available, `web` and `streaming`. | `ClusterIP`, on port 80 for `web` and port 4000 for `streaming` |
| `resources` | Resources to allocate to the containers. | Empty |
| `nodeSelector` | Node selector for the deployments. | Empty |
| `tolerations` | Tolerations list for the deployments. | Empty |
| `affinity` | Affinities for the deployments. | Empty |

### Storage parameters

If persistence is enabled, the following volumes can be defined:
- `assets`: `<mastodon_root_folder>/public/assets`
- `system`: `<mastodon_root_folder>/public/system`

| Parameter  | Description | Default |
|---|---|---|
| `persistence` | Parameters related to data persistence. | See below |
| `persistence.enabled` | Whether to enable persistence of app data | `true` |
| `persistence.existingClaims` | Use existing claims instead of having them created by Helm. Each key is a volume, mapping to the name of the existing claim. | Empty |
| `persistence.accessMode` | Access mode for the claims. | `ReadWriteOnce` |
| `persistence.storageClassName` | Storage class name to require. | Unset (default storage class for the cluster is used) |
| `persistence.resources` | Resources requirements for each claim. Each key is a volume, mapping to a Kubernetes [`VolumeResourceRequirements`](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#resources) mapping. | 10GiB for `assets`, 100GiB for `system` | 
| `volumes` | List of additonal volumes on the deployed pods. | Empty |
| `volumeMounts` | List of additional mounts on the deployed pods. | Empty |

## Usage

See the [fully featured mastodon chart documentation](../../README.md) for more details.
