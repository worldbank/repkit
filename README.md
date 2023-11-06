# repkit

This Stata module is package providing a utility toolkit
for reproducibility best-practices.
The motivation for this package is to make DIME Analytics'
reproducibility best-practices more accessible to a wider Stata community.
The best-practices promoted in this package appreciated
identified and implemented as part of the
[World Bank's reproducibility effort](https://reproducibility.worldbank.org/).

Currently, this toolkit has the following commands:

| Command | Description |
| --- | --- |
| [repado](https://dime-worldbank.github.io/repkit/reference/repado.html) | Command used to manage project ado command dependencies. This command provides a way to make sure that all team members as well as future reproducers of the projects code use the exact same version of all command dependencies. |
| [repkit](https://dime-worldbank.github.io/repkit/reference/repkit.html) | Command named the same as the package. Most important purpose is that this command makes the code `which repkit` work. |

# Installation

While we allow multiple ways of installing the package,
we recommend all users to install the package from SSC
unless there is a very specific reason to not do so.

## Install from SSC

To install from SSC, run this code in your Stata command line.

```
ssc install repkit
```

## Install from GitHub repo

TODO

# Contributions

This package is developed in
[this repo](https://github.com/dime-worldbank/repkit)
on GitHub using the [adodown](https://github.com/lsms-worldbank/adodown) workflow.

We are happy to receive feedback and/or contributions.
Please feel free to report bugs or request new features
by opening up a
[new issue](https://github.com/dime-worldbank/repkit/issues).

You are also welcome to fork this repo and submit a
[pull request](https://github.com/dime-worldbank/repkit/pulls)
with contribution to the code.

# Authors

This package is written and published by
[DIME Analytics](https://www.worldbank.org/en/research/dime/data-and-analytics).
DIME Analytics is a research data methodology team part of the
[Development Impact](https://www.worldbank.org/en/research/dime)
department within the [World Bank](https://www.worldbank.org/).

Contact: dimeanalytics@worldbank.org
