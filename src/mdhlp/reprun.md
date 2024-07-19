# Title

__reprun__ - This command is used to automate a reproducibility check for a single Stata do-file, or a set of do-files called by a main do-file. The command should be used interactively; __reprun__ will execute one run of the do-file and record the state of Stata after the execution of each line. It will then run the entire do-file a second time and flag all potential reproducibility error caused by comparing the Stata state to the first run _after each line_. Debugging and reporting options are available.

# Syntax

__reprun__ "_do-file.do_" [using "_/directory/_"]
, [__**v**erbose__] [__**c**ompact__] [__**s**uppress(rng|srng|dsum|loop)__]
[__**d**ebug__] [__**noc**lear__]

By default, __reprun__ will execute the complete do-file specified in "_do-file.do_" once (Run 1), and record the "seed RNG state", "sort order RNG", and "data checksum" after the execution of every line, as well as the exact data in certain cases. __reprun__ will then execute the do-file a second time (Run 2), and find all _changes_ and _mismatches_ in these states throughout Run 2. A table of mismatches will be reported in the Results window, as well as in a SMCL file in a new directory called `/reprun/` in the same location as the do-file. If the `using` argument is supplied, the `/reprun/` directory containing the SMCL file will be stored in that location instead.

| _options_ | Description |
|-----------|-------------|
| __**v**erbose__   | Report all lines where Run 1 and Run 2 mismatch __**or**__ change for any value  |
| __**c**ompact__   | Report only lines where Run 1 and Run 2 mismatch __**and**__ change for either the seed or sort RNG |
| __**s**uppress(types)__   | Suppress reporting of state changes that do not result in mismatches for seed RNG state (`rng`), sort order RNG (`srng`), and/or data checksum (`dsum`), for any reporting setting  |
| __**d**ebug__   | Save all records of Stata states in Run 1 and Run 2 for inspection in the `/reprun/` folder |
| __**noc**lear__   | Do not reset the Stata state before beginning reproducibility Run 1  |

# Description

The __reprun__ command is intended to be used to check the reproducibility of a do-file or set of do-files (called by a main do-file) that are ready to be transferred to other users or published. The command will ensure that the outputs produced by the do-file or set of do-files are stable across runs, such that they do not produce reproducibility errors caused by incorrectly managed randomness in Stata. To do so, __reprun__ will check three key sources of reproducibility failure at each point in execution of the do-file(s): the state of the random number generator, the sort order of the data, and the contents of the data itself (see detailed description below).

After completing Run 2, __reprun__ will report all lines where there are mismatches between Run 1 and Run 2 in any of these values. Lines where _changes_ lead to _mismatches_ will be highlighted. Problems should be approached top-to-bottom, as solving earlier issues will often resolve later ones. Additionally, addressing issues from left-to-right in the table is effective. RNG states are responsible for most errors, followed by unstable sorts, while data mismatches are typically symptoms of these reproducibility failures rather than causes in and of themselves.

__Mismatches are defined as follows:__

__Seed RNG State:__ A mismatch occurs whenever the RNG state differs from Run 1 to Run 2, _except_ any time the RNG state is exactly equivalent to `set seed 12345` in Run 1 (the initialization default). By default, __reprun__ invokes __clear__ and __set seed 12345__ to match the default Stata state before beginning Run 1. The __noclear__ option prevents this behavior; this is not recommended unless you have a rare issue that you need to check at the very beginning of the file. Most projects should quickly set the randomization seed appropriately for replicability.

__Sort Order RNG:__ Since the sort RNG state should _always_ differ between Run 1 and Run 2, a mismatch is defined as any line where the sort RNG state is advanced _and_ __checksum__ fails to match when compared with the Run 1 data (as a CSV) at the same line. This mismatch occurs when the sort order RNG is used in a command that results in the data taking a different order between the two runs. Users should never manually set the `sortseed` (See `help seed` and `help sortseed`) to override these mismatches; instead, they should implement a unique sort on the data using a command like `isid` (See `help isid`).

__Data Checksum:__ A mismatch occurs whenever __checksum__ fails to match when comparing the result from the Run 1 data (as a CSV) in Run 2. Users should understand that lines where _only_ the data checksum fails to match are unlikely to be where problems originate in the code; these mismatches are generally consequences of earlier reproducibility failures in randomization or sorting. Users should also note that results from __datasignature__ are only unique up to the sort order of each column independently; hence, we do not use this command.


# Options

By default, __reprun__ returns a list of _mismatches_ in Stata state between Run 1 and Run 2. This means that any time the state of the random number generator, the sort order of the data, or the contents of the data itself do not match Run 1 during Run 2, a flag will be generated for the corresponding line of code. The user may modify this reporting in several ways using options.

## Line flagging options

The __**v**erbose__ option can be used to produce even more detail than the default. If the __**v**erbose__ option is specified, then any line in which the state changes _during_ Run 1 or Run 2; __**or**__ mismatches between the runs will be flagged and reported. This is intended to allow the user to do a deep-dive into the function and structure of the do-file's execution.

The __**c**ompact__ option, by contrast, produces less detailed reporting, but is often a good first step to begin locating issues in the code. If the __**c**ompact__ option is specified, then _only_ those lines which have mismatched seed or sort order RNG changes _during_ Run 1 or Run 2 __**and**__ mismatches between the runs will be flagged and reported. Data checksum mismatches alone will be ignored; as will RNG mismatches not accompanied by a change in the state. This is intended to reduce the reporting of "cascading" differences, which are caused because some state value changes inconsistently at a single point and remains inconsistent for the remainder of the run (making every subsequent data change a mismatch, for example).

The __**s**uppress()__ option is used to hide the reporting of changes that do not lead to mismatches (especially when the __**v**erbose__ option is specified) for one or more of the types. In particular, since the sort order RNG frequently changes and should _not_ be forced to match between runs, it will very often have changes that do not produce errors, specifying __**s**uppress(srng)__ will remove a great deal of unhelpful output from the reporting table. To do this for all states, write __**s**uppress(rng srng dsum)__. Suppressing `loop` will clean up the display of loops so that the titles are only shown on the first line; but if combined with `compact` may not display at all.

## Reporting and debugging options

The __**d**ebug__ option allows the user to save all of the underlying materials used by __reprun__ in the `/reprun/` folder where the reporting SMCL file will be written. This will include copies of all do-files for each run for manual inspection and text files of the states of Stata after each line. This is automatically cleaned up after execution if __**d**ebug__ is not specified.

## Other options

By default, __reprun__ invokes __clear__ and __set seed 12345__ to match the default Stata state before beginning Run 1. __**noc**lear__ prevents this behavior. It is not recommended unless you have a rare issue that you need to check at the very beginning of the file, because most projects should very quickly set these states appropriately for reproducibility.

# Examples

## Example 1

This is the most basic usage of __reprun__. Specified in any of the following ways, either in the Stata command window or as part of a new do-file, __reprun__ will execute the complete do-file "_myfile.do_" once (Run 1), and record the "seed RNG state", "sort order RNG", and "data checksum" after the execution of every line, as well as the exact data in certain cases. __reprun__ will then execute "_myfile.do_" a second time (Run 2), and find all _changes_ and _mismatches_ in these states throughout Run 2. A table of mismatches will be reported in the Results window, as well as in a SMCL file in a new directory called `/reprun/` in the same location as "_myfile.do_". 

```
reprun "myfile.do"
```

or 

```
reprun "path/to/folder/myfile.do"
```

or 

```
local myfolder "/path/to/folder"
reprun "`myfolder'/myfile.do"
```

## Example 2

This example is similar to example 1, but the `/reprun/` directory containing the SMCL file will be stored in the location specified by the __using__ argument.

```
reprun "myfile.do" using "path/to/report"
```

or 

```
reprun "path/to/folder/myfile.do" using "path/to/report"
```

or 

```
local myfolder "/path/to/folder"
reprun "`myfolder'/myfile.do" using "`myfolder'/report"
```

## Example 3

Assume "_myfile.do_" contains the following code:

```
sysuse census.dta, clear
isid state, sort
gen group = runiform() < .5
bys group: gen n_obs = _n
drop if n_obs > 22
```

Running a reproducibility check on this do-file using __reprun__ will generate a table listing _mismatches_ in Stata state between Run 1 and Run 2. 

```
reprun "myfile.do"
```


In this specific code block, the following lines will be flagged for mismatches:

Line 3: `gen group = runiform() < .5`
This line generates a new variable `group` based on a random uniform distribution. The RNG state will differ between Run 1 and Run 2 unless the random seed is explicitly set before this command. As a result, a mismatch in the "seed RNG state" will be flagged.

Line 4: `bys group: gen n_obs = _n`
This line sorts the data by the newly generated `group` variable and creates a new variable `n_obs` based on this sorted order. Since group is generated using `runiform()` without setting a seed, it will differ in each run, causing the sort order to vary. As a result, a mismatch in the "sort order RNG" will be flagged. If the sort order is not consistent between runs, the subsequent operations on the data can result in different outputs, causing further mismatches.

Lines 3-5: These lines will also be flagged for "data checksum" mismatches. The `runiform()` function in line 3 introduces randomness, and the `sort` in line 4 can lead to different data orders between runs. These changes propagate to line 5 `drop if n_obs > 22`, where the number of observations dropped may differ between runs due to the changes in `n_obs`. The data checksum comparison will detect these differences, leading to mismatches being flagged.


## Example 4

Using the  __**v**erbose__ option generates more detailed tables where any lines across Run 1 and Run 2 mismatch _**or**_ change for any value. In addition to the output in Example 3, it will also flag line 2 for changes in "seed RNG state" and "data checksum".

```
reprun "myfile.do", verbose
```

## Example 5

Using the __**c**ompact__ option generates less detailed tables where only lines with mismatched seed or sort order RNG changes during Run 1 or Run 2, and mismatches between the runs, are flagged and reported. The output will be similar to Example 3; however, only lines 3 and 4 will be flagged for "data checksum".

```
reprun "myfile.do", compact
```

## Example 6
Running reproducibility check on a set of do-files called by a main do-file. For example, the main do-file might contain the following code:

```
local myfolder "/path/to/folder"
do "`myfolder'/myfile1.do"
do "`myfolder'/myfile2.do
```

Running the reproducibility check on "_main.do_" will return tables listing mismatches in "_myfile1.do_", "_myfile2.do_", and "_main.do_". For instance, if there are mismatches between Run 1 and Run 2 in "_myfile1.do_", every line with mismatches will be flagged in a table. Additionally, line 2 in "_main.do_" will be flagged for calling "_myfile1.do_".

```
reprun "main.do"
```

# Feedback, bug reports and contributions

Read more about these commands on [this repo](https://github.com/worldbank/repkit) where this package is developed. Please provide any feedback by [opening an issue](https://github.com/worldbank/repkit/issues). PRs with suggestions for improvements are also greatly appreciated.

# Authors

LSMS Team, The World Bank lsms@worldbank.org
DIME Analytics, The World Bank dimeanalytics@worldbank.org
