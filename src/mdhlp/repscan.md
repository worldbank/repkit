# Title

__repscan__ - Detect the use of commands linked to common reproducibility failures in Stata do-files.

# Syntax

__repscan__ "_do-file.do_" [, __complete__]

__repscan__ scans a do-file, detecting commands known to possibly compromise reproducibility in Stata code execution.
By default, it flags only commands which have a _high probability_ of causing reproducibility failures.
Using the option _complete_ tells __repscan__ to also flag commands which have a _lower probability_ of causing reproducibility issues.

| _options_ | Description |
|-----------|-------------|
| __complete__ | Runs __repscan__ in _complete_ detection mode, detecting all commands known to cause reproducibility issues in Stata. |

# Description

__repscan__ reads a do-file and flags commands known to potentially compromise reproducibility.
By alerting users of potential problems—such as commands affected by uncontrolled randomness, system-dependent sortings, or unstable default behaviors—__repscan__ allows researchers to refine their code and ensure their results can be reproduced.
The default use of __repscan__ only flags commands with a high probability of causing reproducibility failures, while using the option _complete_ flags commands with a lower probability of causing reproducibility issues as well.

## Commands with a high probability of causing reproducibility issues

1. __Using `runiform()` without setting a random seed__: `runiform()` generates random numbers based on the current state of Stata's random number generator, which is set with a random seed.
If you do not set the seed explicitly (using `set seed`), in your code before using `runiform()`, Stata will produce a different sequence of random numbers each time, breaking reproducibility.

2. __Many-to-many merges__: A many-to-many merge (`merge m:m`) is problematic for reproducibility because the operation matches observations based on the order in which they appear within groups defined by the merge variables.
Since neither dataset is uniquely identified by the merge keys, Stata pairs the first observation in the master dataset with the first in the using dataset, the second with the second, and so on.
If the number of observations differs between datasets for a given group, the last observation of the shorter group is repeatedly matched with the remaining observations of the longer group.
The input datasets of `merge m:m` need to be uniquely and consistently sorted for the result to be reproducible.

3. __Forced dropping of duplicated observations__: Using `duplicates drop varlist, force` may cause reproducibility problems because it keeps only the first occurrence of each duplicate, determined by the current order of the data.
If the dataset is not sorted in a unique and consistent way before running this command, the specific observations that are kept or dropped can vary depending on how the data happened to be ordered at that moment.

## Commands with a lower probability of causing reproducibility issues

1. __Sorting or using bysort__: When using the `sort` command on a variable that contains ties (i.e., multiple observations with the same value), Stata must decide how to order those tied observations.
If there is no additional variable to break the tie, the order among tied observations is not guaranteed to be the same every time you run the code.
The most robust way to ensure reproducibility when sorting is to sort on a variable or set of variables that uniquely identify each observation.

2. __set sortseed__: the `set sortseed` (or `set sortrngstate`) command is sometimes used in an attempt to make the ordering of tied values in sorts reproducible.
However, this approach does not fully solve the problem and can still lead to different results across Stata editions or hardware.
As Stata’s own documentation warns, the command is highly esoteric and not recommended for general use.
The core issue is that Stata prioritizes speed in its sorting algorithms and does not guarantee reproducibility of tie-breaking across different environments.
Specifically, Stata/SE and Stata/MP use the random tie-breaking differently, so even with the same seed or state, the order of tied observations can differ between Stata editions, and even between runs on different numbers of processors.

3. __reclink__: some of the record linkage operations performed by `reclink` may involve tie-breaking when multiple matches are equally likely.
If the code does not control for this (e.g., by sorting data in a stable, unique way before matching), the results may differ across runs or environments.

4. __Setting a random seed without specifying a Stata version first__: setting the random seed without first specifying the version can break reproducibility because the random-number generation algorithms may change between versions.
By setting the version first (using the `version` command), you ensure that Stata uses the same algorithms as in that specified version, making your results consistent and reproducible across different environments and over time.

## Skipping lines

__repscan__ will skip lines ending with the in-line comment: _RESPCAN OK_.
This can be used to avoid flagging issues the user knows will not break reproducibility.
For example, a line with:

```
* Unique sorting
sort id // REPSCAN OK
```

Will be skipped by __repscan__ when using the command with the option _complete_.

# Examples

Basic functionality:

```
repscan "path/to/do-file.do"
```

Complete functionality:

```
repscan "path/to/do-file.do", complete
```

# Feedback, bug reports and contributions

`repscan` is part of the Stata package `repkit`, containing tools for reproducible Stata coding.
Read more about these commands on [this repository](https://github.com/worldbank/repkit) where this package is developed.
Provide any feedback by [opening an issue](https://github.com/worldbank/repkit/issues).
Pull requests with suggestions for improvements or bug fixes are also greatly appreciated.

# Authors

DIME Analytics, The World Bank dimeanalytics@worldbank.org

# Acknowledgements

Christian Walker tested the command extensively on actual code and reported bugs to the authors.
