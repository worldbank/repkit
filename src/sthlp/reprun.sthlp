{smcl}
{* 01 Jan 1960}{...}
{hline}
{pstd}help file for {hi:reprun}{p_end}
{hline}

{title:Title}

{phang}{bf:reprun} - This command is used to automate a replication check for a single Stata do-file, or a set of do-files called by a main do-file. The command should be used interactively; {bf:reprun} will execute one run of the do-file and record the state of Stata after the execution of each line. It will then run the entire do-file a second time and flag all potential replication errors by comparing the Stata state after each line to the first run. Debugging and reporting options are available.
{p_end}

{title:Syntax}

{phang}{bf:reprun} {c 34}{it:do-file}{c 34} [using {c 34}{it:output directory}{c 34}]
, [{bf:verbose}] [{bf:compact}] [{bf:{ul:s}uppress(rng|srng|dsig)}]
[{bf:{ul:noc}lear}] [{bf:debug}]
{p_end}

{title:Options}

{title:Description}
{pstd}The {bf:reprun} command is intended to be used to check the replicability of a do-file or set of do-files (called by a main do-file) that are ready to be transferred to other users or published. The command will ensure that the outputs produced by the do-file or set of do-files are stable across runs, such that they do not produce replicability errors caused by incorrectly managed randomness in Stata. To do so, {bf:reprun} will check three key sources of replication failure at each point in execution of the do-file(s): the state of the random number generator, the sort order of the data, and the contents of the data itself.
{p_end}

{pstd}{bf:{ul:opt}ion1}({it:string}) is used for xyz. Longer description (paragraph length) of all options, their intended use case and best practices related to them.
{p_end}

{title:Examples}

{title:Feedback, bug reports and contributions}

{title:Authors}

{pstd}TODO: Populate this field from .pkg file
{p_end}
