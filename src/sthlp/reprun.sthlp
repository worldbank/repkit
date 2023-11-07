{smcl}
{* 01 Jan 1960}{...}
{hline}
{pstd}help file for {hi:reprun}{p_end}
{hline}

{title:Title}

{phang}{bf:reprun} - This command is used to automate a replication check for a single Stata do-file, or a set of do-files called by a main do-file. The command should be used interactively; {bf:reprun} will execute one run of the do-file and record the state of Stata after the execution of each line. It will then run the entire do-file a second time and flag all potential replication error causes by comparing the Stata state to the first run {it:after each line}. Debugging and reporting options are available.
{p_end}

{title:Syntax}

{phang}{bf:reprun} {c 34}{it:do-file.do}{c 34} [using {c 34}{it:/directory/}{c 34}]
, [{bf:{ul:v}erbose}] [{bf:{ul:c}ompact}] [{bf:{ul:s}uppress(rng|srng|dsig)}]
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
{synopt: {bf:{ul:noc}lear}}Do not reset the Stata state before beginning replication Run 1{p_end}
{synoptline}

{title:Description}

{pstd}The {bf:reprun} command is intended to be used to check the replicability of a do-file or set of do-files (called by a main do-file) that are ready to be transferred to other users or published. The command will ensure that the outputs produced by the do-file or set of do-files are stable across runs, such that they do not produce replicability errors caused by incorrectly managed randomness in Stata. To do so, {bf:reprun} will check three key sources of replication failure at each point in execution of the do-file(s): the state of the random number generator, the sort order of the data, and the contents of the data itself.
{p_end}

{title:Options}

{pstd}{bf:{ul:opt}ion1}({it:string}) is used for xyz. Longer description (paragraph length) of all options, their intended use case and best practices related to them.
{p_end}

{title:Examples}

{title:Feedback, bug reports and contributions}

{title:Authors}

{pstd}TODO: Populate this field from .pkg file
{p_end}
