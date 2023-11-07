# Title

__reprun__ - This command is used to automate a replication check for a single Stata do-file, or a set of do-files called by a main do-file. The command should be used interactively; __reprun__ will execute one run of the do-file and record the state of Stata after the execution of each line. It will then run the entire do-file a second time and flag all potential replication errors by comparing the Stata state after each line to the first run. Debugging and reporting options are available.

# Syntax

__reprun__ "_do-file_" [using "_output directory_"]
, [__**v**erbose__] [__**c**ompact__] [__**s**uppress(rng|srng|dsig)__]
[__**noc**lear__] [__**d**ebug__]

| _options_ | Description |
|-----------|-------------|
| __**opt**ion1__(_string_)   | Short description of option1  |
| __**opt**ion2__(_string_)   | Short description of option1  |

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
