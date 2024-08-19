# Crunchy Postgres Helm Chart

[Crunchy Postgres](https://access.crunchydata.com/documentation/postgres-operator/latest) is a Kubernetes native Postgres solution. This chart comes from the [official GitHub repository](https://github.com/CrunchyData/postgres-operator-examples/tree/main/helm/postgres), because for some reason, Crunchy Data decided against distributing this Helm chart through a Helm repository, choosing instead to offer examples to be forked and played with. 

The installation and configuration instructions are available in the [official documentation](https://access.crunchydata.com/documentation/postgres-operator/latest/tutorials/basic-setup/create-cluster#use-helm-to-create-a-postgres-cluster). You should use it as a reference for configuring the chart. You can also read the [`values.yaml
`](values.yaml) file which contains every configuration key.
