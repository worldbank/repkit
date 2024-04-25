# Title

__reprun__ - This command is used to automate a reproducibility check for a single Stata do-file, or a set of do-files called by a main do-file. The command should be used interactively; __reprun__ will execute one run of the do-file and record the state of Stata after the execution of each line. It will then run the entire do-file a second time and flag all potential reproducibility error causes by comparing the Stata state to the first run _after each line_. Debugging and reporting options are available.

# Syntax

__reprun__ "_do-file.do_" [using "_/directory/_"]
, [__**v**erbose__] [__**c**ompact__] [__**s**uppress(rng|srng|dsig|loop)__]
[__**d**ebug__] [__**noc**lear__]

By default, __reprun__ will execute the complete do-file specified in "_do-file.do_" once (Run 1), and record the "seed RNG state", "sort order RNG", and "data signature" after the execution of every line, as well as the exact data in certain cases. __reprun__ will then execute the do-file a second time (Run 2), and find all _changes_ and _mismatches_ in these states throughout Run 2. A table of mismatches will be reported in the Results window, as well as in a SMCL file in a new directory called `/reprun/` in the same location as the do-file. If the `using` argument is supplied, the `/reprun/` directory containing the SMCL file will be stored in that location instead.

| _options_ | Description |
|-----------|-------------|
| __**v**erbose__   | Report all lines where Run 1 and Run 2 mismatch __or__ change for any value  |
| __**c**ompact__   | Report only lines where Run 1 and Run 2 mismatch __and__ change for any value  |
| __**s**uppress(types)__   | Suppress reporting of state changes that do not result in mismatches for seed RNG state (`rng`), sort order RNG (`srng`), and/or data signature (`dsig`), for any reporting setting  |
| __**d**ebug__   | Save all records of Stata states in Run 1 and Run 2 for inspection in the `/reprun/` folder |
| __**noc**lear__   | Do not reset the Stata state before beginning reproducibility Run 1  |

# Description

The __reprun__ command is intended to be used to check the reproducibility of a do-file or set of do-files (called by a main do-file) that are ready to be transferred to other users or published. The command will ensure that the outputs produced by the do-file or set of do-files are stable across runs, such that they do not produce reproducibility errors caused by incorrectly managed randomness in Stata. To do so, __reprun__ will check three key sources of reproducibility failure at each point in execution of the do-file(s): the state of the random number generator, the sort order of the data, and the contents of the data itself.

After completing Run 2, __reprun__ will report all lines where there are mismatches in any of these values between Run 1 and Run 2. Lines where _changes_ lead to _mismatches_ will be highlighted, and an indicator for potentially "cascading" mismatches (those caused by previous changes) will be shown by a vertical line and the absence of the change flag. In general, this structure means that problems should be, to a first approximation, approached top-to-bottom, as solving an earlier issue will often resolve later ones (since later changes may not be the ones causing the mismatches). In addition, we have set things up so that problems should also in general be approached from left-to-right in this table. RNG states are responsible for most errors; then unstable sorts; and data mismatches are typically symptoms of these reproducibility failures, rather than causes in and of themselves.

# Options

By default, __reprun__ returns a list of _mismatches_ in Stata state between Run 1 and Run 2. This means that any time the state of the random number generator, the sort order of the data, or the contents of the data itself do not match Run 1 during Run 2, a flag will be generated for the corresponding line of code. The user may modify this reporting in several ways using options.

## Line flagging options

The __**v**erbose__ option can be used to produce even more detail than the default. If the __**v**erbose__ option is specified, then any line in which the state changes _during_ Run 1 or Run 2; or mismatches _between_ the runs will be flagged and reported. This is intended to allow the user to do a deep-dive into the function and structure of the do-file's execution.

The __**c**ompact__ option, by contrast, produces less detailed reporting, but is often a good first step to begin locating issues in the code. If the __**c**ompact__ option is specified, then _only_ those lines which have changes _during_ Run 1 or Run 2 __and__ mismatches _between_ the runs will be flagged and reported. This is intended to reduce the reporting of "cascading" flags, which are caused because some state value changes inconsistently at a single point and remains inconsistent for the remainder of the run.

The __**s**uppress()__ option is used to hide the reporting of changes that do not lead to mismatches (especially when the __**v**erbose__ option is specified) for one or more of the types. In particular, since the sort order RNG frequently changes and should _not_ be forced to match between runs, it will very often have changes that do not produce errors, specifying __**s**uppress(srng)__ will remove a great deal of unhelpful output from the reporting table. To do this for all states, write __**s**uppress(rng srng dsig)__. Suppressing `loop` will clean up the display of loops so that the titles are only shown on the first line; but if combined with `compact` may not display at all.

## Reporting and debugging options

The __**d**ebug__ option allows the user to save all of the underlying materials used by __reprun__ in the `/reprun/` folder where the reporting SMCL file will be written. This will include copies of all do-files for each run for manual inspection, text files of the states of Stata after each line, and copies of the dataset at specific lines when it is needed. This can take a lot of space, and is automatically cleaned up after execution if __**d**ebug__ is not specified.

## Other options

By default, __reprun__ invokes __clear__ and __set seed 12345__ to match the default Stata state before beginning Run 1. __**noc**lear__ prevents this behavior. It is not recommended unless you have a rare issue that you need to check at the very beginning of the file, because most projects should very quickly set these states appropriately for reproducibility.

# Feedback, bug reports and contributions

Read more about these commands on [this repo](https://github.com/worldbank/repkit) where this package is developed. Please provide any feedback by [opening an issue](https://github.com/worldbank/repkit/issues). PRs with suggestions for improvements are also greatly appreciated.

# Authors

LSMS Team, The World Bank lsms@worldbank.org
DIME Analytics, The World Bank dimenalytics@worldbank.org
