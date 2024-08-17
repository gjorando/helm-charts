# Mastodon Helm Charts

This is the Helm repository that hosts different charts related to the [Mastodon](https://joinmastodon.org/) project.

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

```
help repo add mastodon https://gjorando.github.io/helm-charts
```

If you had already added this repo earlier, run `helm repo update` to retrieve the latest versions of the packages.  You can then run `helm search repo mastodon` to see the charts.

See the [Github repository](https://github.com/gjorando/helm-charts) for more informations about deploying the charts in this repository. If you are in a rush, the main chart can be installed as followed:

```
helm upgrade --install my-mastodon mastodon/mastodon
```

