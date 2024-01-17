{smcl}
{* 17 Jan 2024}{...}
{hline}
{pstd}help file for {hi:reprun}{p_end}
{hline}

{title:Title}

{phang}{bf:reprun} - This command is used to automate a reproducibility check for a single Stata do-file, or a set of do-files called by a main do-file. The command should be used interactively; {bf:reprun} will execute one run of the do-file and record the state of Stata after the execution of each line. It will then run the entire do-file a second time and flag all potential reproducibility error causes by comparing the Stata state to the first run {it:after each line}. Debugging and reporting options are available.
{p_end}

{title:Syntax}

{phang}{bf:reprun} {c 34}{it:do-file.do}{c 34} [using {c 34}{it:/directory/}{c 34}]
, [{bf:{ul:v}erbose}] [{bf:{ul:c}ompact}] [{bf:{ul:s}uppress(rng|srng|dsig|loop)}]
[{bf:{ul:d}ebug}] [{bf:{ul:noc}lear}]
{p_end}

{phang}By default, {bf:reprun} will execute the complete do-file specified in {c 34}{it:do-file.do}{c 34} once (Run 1), and record the {c 34}seed RNG state{c 34}, {c 34}sort order RNG{c 34}, and {c 34}data signature{c 34} after the execution of every line, as well as the exact data in certain cases. {bf:reprun} will then execute the do-file a second time (Run 2), and find all {it:changes} and {it:mismatches} in these states throughout Run 2. A table of mismatches will be reported in the Results window, as well as in a SMCL file in a new directory called {inp:/reprun/} in the same location as the do-file. If the {inp:using} argument is supplied, the {inp:/reprun/} directory containing the SMCL file will be stored in that location instead.
{p_end}

{synoptset 15}{...}
{synopthdr:options}
{synoptline}
{synopt: {bf:{ul:v}erbose}}Report all lines where Run 1 and Run 2 mismatch {bf:or} change for any value{p_end}
{synopt: {bf:{ul:c}ompact}}Report only lines where Run 1 and Run 2 mismatch {bf:and} change for any value{p_end}
{synopt: {bf:{ul:s}uppress(types)}}Suppress reporting of state changes that do not result in mismatches for seed RNG state ({inp:rng}), sort order RNG ({inp:srng}), and/or data signature ({inp:dsig}), for any reporting setting{p_end}
{synopt: {bf:{ul:d}ebug}}Save all records of Stata states in Run 1 and Run 2 for inspection in the {inp:/reprun/} folder{p_end}
{synopt: {bf:{ul:noc}lear}}Do not reset the Stata state before beginning reproducibility Run 1{p_end}
{synoptline}

{title:Description}

{pstd}The {bf:reprun} command is intended to be used to check the reproducibility of a do-file or set of do-files (called by a main do-file) that are ready to be transferred to other users or published. The command will ensure that the outputs produced by the do-file or set of do-files are stable across runs, such that they do not produce reproducibility errors caused by incorrectly managed randomness in Stata. To do so, {bf:reprun} will check three key sources of reproducibility failure at each point in execution of the do-file(s): the state of the random number generator, the sort order of the data, and the contents of the data itself.
{p_end}

{pstd}After completing Run 2, {bf:reprun} will report all lines where there are mismatches in any of these values between Run 1 and Run 2. Lines where {it:changes} lead to {it:mismatches} will be highlighted, and an indicator for potentially {c 34}cascading{c 34} mismatches (those caused by previous changes) will be shown by a vertical line and the absence of the change flag. In general, this structure means that problems should be, to a first approximation, approached top-to-bottom, as solving an earlier issue will often resolve later ones (since later changes may not be the ones causing the mismatches). In addition, we have set things up so that problems should also in general be approached from left-to-right in this table. RNG states are responsible for most errors; then unstable sorts; and data mismatches are typically symptoms of these reproducibility failures, rather than causes in and of themselves.
{p_end}

{title:Options}

{pstd}By default, {bf:reprun} returns a list of {it:mismatches} in Stata state between Run 1 and Run 2. This means that any time the state of the random number generator, the sort order of the data, or the contents of the data itself do not match Run 1 during Run 2, a flag will be generated for the corresponding line of code. The user may modify this reporting in several ways using options.
{p_end}

{dlgtab:Line flagging options}

{pstd}The {bf:{ul:v}erbose} option can be used to produce even more detail than the default. If the {bf:{ul:v}erbose} option is specified, then any line in which the state changes {it:during} Run 1 or Run 2; or mismatches {it:between} the runs will be flagged and reported. This is intended to allow the user to do a deep-dive into the function and structure of the do-file{c 39}s execution.
{p_end}

{pstd}The {bf:{ul:c}ompact} option, by contrast, produces less detailed reporting, but is often a good first step to begin locating issues in the code. If the {bf:{ul:c}ompact} option is specified, then {it:only} those lines which have changes {it:during} Run 1 or Run 2 {bf:and} mismatches {it:between} the runs will be flagged and reported. This is intended to reduce the reporting of {c 34}cascading{c 34} flags, which are caused because some state value changes inconsistently at a single point and remains inconsistent for the remainder of the run.
{p_end}

{pstd}The {bf:{ul:s}uppress()} option is used to hide the reporting of changes that do not lead to mismatches (especially when the {bf:{ul:v}erbose} option is specified) for one or more of the types. In particular, since the sort order RNG frequently changes and should {it:not} be forced to match between runs, it will very often have changes that do not produce errors, specifying {bf:{ul:s}uppress(srng)} will remove a great deal of unhelpful output from the reporting table. To do this for all states, write {bf:{ul:s}uppress(rng srng dsig)}. Suppressing {inp:loop} will clean up the display of loops so that the titles are only shown on the first line; but if combined with {inp:compact} may not display at all.
{p_end}

{dlgtab:Reporting and debugging options}

{pstd}The {bf:{ul:d}ebug} option allows the user to save all of the underlying materials used by {bf:reprun} in the {inp:/reprun/} folder where the reporting SMCL file will be written. This will include copies of all do-files for each run for manual inspection, text files of the states of Stata after each line, and copies of the dataset at specific lines when it is needed. This can take a lot of space, and is automatically cleaned up after execution if {bf:{ul:d}ebug} is not specified.
{p_end}

{dlgtab:Other options}

{pstd}By default, {bf:reprun} invokes {bf:clear} and {bf:set seed 12345} to match the default Stata state before beginning Run 1. {bf:{ul:noc}lear} prevents this behavior. It is not recommended unless you have a rare issue that you need to check at the very beginning of the file, because most projects should very quickly set these states appropriately for reproducibility.
{p_end}

{title:Feedback, bug reports and contributions}

{pstd}Read more about these commands on {browse "https://github.com/dime-worldbank/repkit":this repo} where this package is developed. Please provide any feedback by {browse "https://github.com/dime-worldbank/repkit/issues":opening an issue}. PRs with suggestions for improvements are also greatly appreciated.
{p_end}

{title:Authors}

{pstd}DIME Analytics, The World Bank dimenalytics@worldbank.org
{p_end}
