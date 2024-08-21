# Mastodon Helm Charts repository

This repository contains the various Helm charts maintained by ~~Mastodon~~ Renn (it's me), who apparently decided they were k8s-savvy enough (after one (1) week of sleepless nights trying to migrate their home infrastructure) to tackle this problem. Anyways, see the [Github project](https://github.com/users/gjorando/projects/1) for the roadmap I have in mind.

![Renn is tired in anticipation](sticker.webp "I will remove this at some point (... unless)")

## Usage

The charts are published to [a Github Helm repository](https://gjorando.github.io/helm-charts). You can install or update it using the following command: `help repo add mastodon https://gjorando.github.io/helm-charts --force-update`. Once this is done, use `helm search repo mastodon` to look into the repository.
