# repkit

This Stata module is a package providing a utility toolkit
for reproducibility best-practices.
The motivation for this package is to make the World Bank's
reproducibility best-practices more accessible to a wider Stata community.
The best-practices promoted in this package appreciated
identified and implemented as part of the
[World Bank's reproducibility effort](https://reproducibility.worldbank.org/).

Currently, this toolkit has the following commands:

| Command | Description |
| --- | --- |
| [repado](https://worldbank.github.io/repkit/reference/repado.html) | Command used to manage a project's dependencies of commands installed from external sources such as SSC. This command provides a way to make sure that all team members as well as future reproducers of the projects code use the exact same version of all command dependencies. |
| [repadolog](https://worldbank.github.io/repkit/reference/repadolog.html) | Outputs a report of the commands installed in the current PLUS folder. |
| [repkit](https://worldbank.github.io/repkit/reference/repkit.html) | Command named the same as the package. Most important purpose is that this command makes the code `which repkit` work. |
| [reproot](https://worldbank.github.io/repkit/reference/reproot.html) | This command allows teams to dynamically set root-paths with no manual user-specific set-up, in both single-rooted and multi-rooted projects. |
| [reproot_setup](https://worldbank.github.io/repkit/reference/reproot_setup.html) | This command helps setting up the environment setting file used in `reproot` |
| [reprun](https://worldbank.github.io/repkit/reference/reprun.html) | This command is used to automate reproducibility checks by running a do-file or a set of do-files and compare all state values (RNG-value, datasignature etc.) between the two runs. This command is currently only release as a beta-version. |
| lint | `lint` is an opinionated detector that attempts to improve the readability and organization of Stata do files. The command is written based on the good coding practices of the Development Impact Evaluation Unit at The World Bank.|

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

You can install older versions of `repkit` directly from the GitHub repository.
To do so, start by finding the tag corresponding to
the version you want to install here:
https://github.com/worldbank/repkit/tags.
Update the local "tag" in the code below with the value of the tag you picked,
and then run the code.

```
local tag "v1.0"
net install repkit, ///
  from("https://raw.githubusercontent.com/worldbank/repkit/`tag'/src")
```

# Contributions

This package is developed in
[this repo](https://github.com/worldbank/repkit)
on GitHub using the [adodown](https://github.com/lsms-worldbank/adodown) workflow.

We are happy to receive feedback and/or contributions.
Please feel free to report bugs or request new features
by opening up a
[new issue](https://github.com/worldbank/repkit/issues).

You are also welcome to fork this repo and submit a
[pull request](https://github.com/worldbank/repkit/pulls)
with contribution to the code.

# Authors

This package is written and published by
[DIME Analytics](https://www.worldbank.org/en/research/dime/data-and-analytics)
and the [LSMS Team](https://www.worldbank.org/en/programs/lsms).
Both teams are teams within the [World Bank](https://www.worldbank.org/)
DIME Analytics is a research data methodology team part of the
[Development Impact](https://www.worldbank.org/en/research/dime) department.
The Living Standards Measurement Study (LSMS) is the World Bank's
flagship household survey program and is
part of the World Bank’s
[Development Data Group](https://www.worldbank.org/en/about/unit/unit-dec/dev).

Contact:
- dimeanalytics@worldbank.org
- lsms@worldbank.org
