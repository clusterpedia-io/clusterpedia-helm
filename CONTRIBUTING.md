# Contributing

Clusterpedia helm is the most important installation of clusterpedia, Therefore we rely on you to test your changes sufficiently. we've also added some of verification and testing workflow to reduce simple mistakes. 

Everyone's contribution to the community is very welcome.

# Pull Requests

All submissions, including submissions by project members, require review. We use GitHub pull requests for this purpose. Consult [GitHub Help](https://help.github.com/articles/about-pull-requests/) for more information on using pull requests. See the above stated requirements for PR on this project.

## Versioning

Each chart's version follows the [semver standard](https://semver.org/). New charts should start at version `1.0.0`, if it's considered stable. If it's not considered stable, it must be released as [prerelease](#prerelease).

Any breaking changes to a chart (backwards incompatible) require:

  * Bump of the current Major version of the chart
  * State possible manual changes for this chart version in the `Upgrading` section of the chart's `README.md.gotmpl` ([See Upgrade](#upgrades))

### Immutability

Each release for each chart must be immutable. Any change to a chart (even just documentation) requires a version bump. Trying to release the same version twice will result in an error.

## Documentation

The documentation for each chart is done with [helm-docs](https://github.com/norwoodj/helm-docs). This way we can ensure that values are consistent with the chart documentation.

We have a script on the repository which will execute the helm-docs docker container, so that you don't have to worry about downloading the binary etc. Simply execute the script (Bash compatible, might require sudo privileges):

```
bash scripts/helm-docs.sh
```
