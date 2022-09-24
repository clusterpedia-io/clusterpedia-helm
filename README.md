# Clusterpedia Helm Charts

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Install Dependce

Since Clusterpedia uses `bitnami/postgresql` and `bitnami/mysql` as subcharts of storage components, it is necessary to add the bitnami repository and update the dependencies of the clusterpedia chart.

```shell
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm dependency build
```

## Local Installation

Pull the Clusterpedia repository.

```shell
$ git clone https://github.com/clusterpedia-io/clusterpedia-helm.git
$ cd clusterpedia-helm/charts/clusterpedia
```

## Remote Installation

Add the Clusterpedia chart repo to your local repository.

```shell
$ helm repo add clusterpedia https://clusterpedia-io.github.io/clusterpedia/charts
$ helm repo list
```

## Contributing

We'd love to have you contribute! Please refer to our [contribution guidelines](CONTRIBUTING.md) for details.
