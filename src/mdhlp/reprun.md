# Title

__reprun__ - This command is used to automate a replication check for a single Stata do-file, or a set of do-files called by a main do-file. The command should be used interactively; __reprun__ will execute one run of the do-file and record the state of Stata after the execution of each line. It will then run the entire do-file a second time and flag all potential replication error causes by comparing the Stata state to the first run _after each line_. Debugging and reporting options are available.

# Syntax

__reprun__ "_do-file.do_" [using "_/directory/_"]
, [__**v**erbose__] [__**c**ompact__] [__**s**uppress(rng|srng|dsig)__]
[__**d**ebug__] [__**noc**lear__]

By default, __reprun__ will execute the complete do-file specified in "_do-file.do_" once (Run 1), and record the "seed RNG state", "sort order RNG", and "data signature" after the execution of every line, as well as the exact data in certain cases. __reprun__ will then execute the do-file a second time (Run 2), and find all _changes_ and _mismatches_ in these states throughout Run 2. A table of mismatches will be reported in the Results window, as well as in a SMCL file in a new directory called `/reprun/` in the same location as the do-file. If the `using` argument is supplied, the `/reprun/` directory containing the SMCL file will be stored in that location instead.

| _options_ | Description |
|-----------|-------------|
| __**v**erbose__   | Report all lines where Run 1 and Run 2 mismatch __or__ change for any value  |
| __**c**ompact__   | Report only lines where Run 1 and Run 2 mismatch __and__ change for any value  |
| __**s**uppress(types)__   | Suppress reporting of state changes that do not result in mismatches for seed RNG state (`rng`), sort order RNG (`srng`), and/or data signature (`dsig`), for any reporting setting  |
| __**d**ebug__   | Save all records of Stata states in Run 1 and Run 2 for inspection in the `/reprun/` folder |
| __**noc**lear__   | Do not reset the Stata state before beginning replication Run 1  |

# Description

The __reprun__ command is intended to be used to check the replicability of a do-file or set of do-files (called by a main do-file) that are ready to be transferred to other users or published. The command will ensure that the outputs produced by the do-file or set of do-files are stable across runs, such that they do not produce replicability errors caused by incorrectly managed randomness in Stata. To do so, __reprun__ will check three key sources of replication failure at each point in execution of the do-file(s): the state of the random number generator, the sort order of the data, and the contents of the data itself.

# Options
<!-- Longer description (paragraph length) of all options, their intended use case and best practices related to them. -->

__**opt**ion1__(_string_) is used for xyz. Longer description (paragraph length) of all options, their intended use case and best practices related to them.

# Examples
<!-- A couple of examples to help the user get started and a short explanation of each of them. -->

# Feedback, bug reports and contributions
<!-- A couple of examples to help the user get started and a short explanation of each of them. -->

# Authors

TODO: Populate this field from .pkg file
