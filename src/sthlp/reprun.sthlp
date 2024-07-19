{smcl}
{* *! version 2.1 20240516}{...}
{hline}
{pstd}help file for {hi:reprun}{p_end}
{hline}

{title:Title}

{phang}{bf:reprun} - This command is used to automate a reproducibility check for a single Stata do-file, or a set of do-files called by a main do-file. The command should be used interactively; {bf:reprun} will execute one run of the do-file and record the state of Stata after the execution of each line. It will then run the entire do-file a second time and flag all potential reproducibility error caused by comparing the Stata state to the first run {it:after each line}. Debugging and reporting options are available.
{p_end}

{title:Syntax}

{phang}{bf:reprun} {c 34}{it:do-file.do}{c 34} [using {c 34}{it:/directory/}{c 34}]
, [{bf:{ul:v}erbose}] [{bf:{ul:c}ompact}] [{bf:{ul:s}uppress(rng|srng|dsum|loop)}]
[{bf:{ul:d}ebug}] [{bf:{ul:noc}lear}]
{p_end}

{phang}By default, {bf:reprun} will execute the complete do-file specified in {c 34}{it:do-file.do}{c 34} once (Run 1), and record the {c 34}seed RNG state{c 34}, {c 34}sort order RNG{c 34}, and {c 34}data checksum{c 34} after the execution of every line, as well as the exact data in certain cases. {bf:reprun} will then execute the do-file a second time (Run 2), and find all {it:changes} and {it:mismatches} in these states throughout Run 2. A table of mismatches will be reported in the Results window, as well as in a SMCL file in a new directory called {inp:/reprun/} in the same location as the do-file. If the {inp:using} argument is supplied, the {inp:/reprun/} directory containing the SMCL file will be stored in that location instead. 
{p_end}

{synoptset 15}{...}
{p2coldent:{it:options}}Description{p_end}
{synoptline}
{synopt: {bf:{ul:v}erbose}}Report all lines where Run 1 and Run 2 mismatch {bf:{ul:or}} change for any value{p_end}
{synopt: {bf:{ul:c}ompact}}Report only lines where Run 1 and Run 2 mismatch {bf:{ul:and}} change for either the seed or sort RNG{p_end}
{synopt: {bf:{ul:s}uppress(types)}}Suppress reporting of state changes that do not result in mismatches for seed RNG state ({inp:rng}), sort order RNG ({inp:srng}), and/or data checksum ({inp:dsum}), for any reporting setting{p_end}
{synopt: {bf:{ul:d}ebug}}Save all records of Stata states in Run 1 and Run 2 for inspection in the {inp:/reprun/} folder{p_end}
{synopt: {bf:{ul:noc}lear}}Do not reset the Stata state before beginning reproducibility Run 1{p_end}
{synoptline}

{title:Description}

{pstd}The {bf:reprun} command is intended to be used to check the reproducibility of a do-file or set of do-files (called by a main do-file) that are ready to be transferred to other users or published. The command will ensure that the outputs produced by the do-file or set of do-files are stable across runs, such that they do not produce reproducibility errors caused by incorrectly managed randomness in Stata. To do so, {bf:reprun} will check three key sources of reproducibility failure at each point in execution of the do-file(s): the state of the random number generator, the sort order of the data, and the contents of the data itself (see detailed description below).
{p_end}

{pstd}After completing Run 2, {bf:reprun} will report all lines where there are mismatches between Run 1 and Run 2 in any of these values. Lines where {it:changes} lead to {it:mismatches} will be highlighted. Problems should be approached top-to-bottom, as solving earlier issues will often resolve later ones. Additionally, addressing issues from left-to-right in the table is effective. RNG states are responsible for most errors, followed by unstable sorts, while data mismatches are typically symptoms of these reproducibility failures rather than causes in and of themselves.
{p_end}

{pstd}{bf:Mismatches are defined as follows:}
{p_end}

{pstd}{bf:Seed RNG State:} A mismatch occurs whenever the RNG state differs from Run 1 to Run 2, {it:except} any time the RNG state is exactly equivalent to {inp:set seed 12345} in Run 1 (the initialization default). By default, {bf:reprun} invokes {bf:clear} and {bf:set seed 12345} to match the default Stata state before beginning Run 1. The {bf:noclear} option prevents this behavior; this is not recommended unless you have a rare issue that you need to check at the very beginning of the file. Most projects should quickly set the randomization seed appropriately for replicability. 
{p_end}

{pstd}{bf:Sort Order RNG:} Since the sort RNG state should {it:always} differ between Run 1 and Run 2, a mismatch is defined as any line where the sort RNG state is advanced {it:and} {bf:checksum} fails to match when compared with the Run 1 data (as a CSV) at the same line. This mismatch occurs when the sort order RNG is used in a command that results in the data taking a different order between the two runs. Users should never manually set the {inp:sortseed} (See {inp:help seed} and {inp:help sortseed}) to override these mismatches; instead, they should implement a unique sort on the data using a command like {inp:isid} (See {inp:help isid}). 
{p_end}

{pstd}{bf:Data Checksum:} A mismatch occurs whenever {bf:checksum} fails to match when comparing the result from the Run 1 data (as a CSV) in Run 2. Users should understand that lines where {it:only} the data checksum fails to match are unlikely to be where problems originate in the code; these mismatches are generally consequences of earlier reproducibility failures in randomization or sorting. Users should also note that results from {bf:datasignature} are only unique up to the sort order of each column independently; hence, we do not use this command.
{p_end}

{title:Options}

{pstd}By default, {bf:reprun} returns a list of {it:mismatches} in Stata state between Run 1 and Run 2. This means that any time the state of the random number generator, the sort order of the data, or the contents of the data itself do not match Run 1 during Run 2, a flag will be generated for the corresponding line of code. The user may modify this reporting in several ways using options.
{p_end}

{dlgtab:Line flagging options}

{pstd}The {bf:{ul:v}erbose} option can be used to produce even more detail than the default. If the {bf:{ul:v}erbose} option is specified, then any line in which the state changes {it:during} Run 1 or Run 2; {bf:{ul:or}} mismatches between the runs will be flagged and reported. This is intended to allow the user to do a deep-dive into the function and structure of the do-file{c 39}s execution.
{p_end}

{pstd}The {bf:{ul:c}ompact} option, by contrast, produces less detailed reporting, but is often a good first step to begin locating issues in the code. If the {bf:{ul:c}ompact} option is specified, then {it:only} those lines which have mismatched seed or sort order RNG changes {it:during} Run 1 or Run 2 {bf:{ul:and}} mismatches between the runs will be flagged and reported. Data checksum mismatches alone will be ignored; as will RNG mismatches not accompanied by a change in the state. This is intended to reduce the reporting of {c 34}cascading{c 34} differences, which are caused because some state value changes inconsistently at a single point and remains inconsistent for the remainder of the run (making every subsequent data change a mismatch, for example).
{p_end}

{pstd}The {bf:{ul:s}uppress()} option is used to hide the reporting of changes that do not lead to mismatches (especially when the {bf:{ul:v}erbose} option is specified) for one or more of the types. In particular, since the sort order RNG frequently changes and should {it:not} be forced to match between runs, it will very often have changes that do not produce errors, specifying {bf:{ul:s}uppress(srng)} will remove a great deal of unhelpful output from the reporting table. To do this for all states, write {bf:{ul:s}uppress(rng srng dsum)}. Suppressing {inp:loop} will clean up the display of loops so that the titles are only shown on the first line; but if combined with {inp:compact} may not display at all. 
{p_end}

{dlgtab:Reporting and debugging options}

{pstd}The {bf:{ul:d}ebug} option allows the user to save all of the underlying materials used by {bf:reprun} in the {inp:/reprun/} folder where the reporting SMCL file will be written. This will include copies of all do-files for each run for manual inspection and text files of the states of Stata after each line. This is automatically cleaned up after execution if {bf:{ul:d}ebug} is not specified. 
{p_end}

{dlgtab:Other options}

{pstd}By default, {bf:reprun} invokes {bf:clear} and {bf:set seed 12345} to match the default Stata state before beginning Run 1. {bf:{ul:noc}lear} prevents this behavior. It is not recommended unless you have a rare issue that you need to check at the very beginning of the file, because most projects should very quickly set these states appropriately for reproducibility.
{p_end}

{title:Examples}

{dlgtab:Example 1}

{pstd}This is the most basic usage of {bf:reprun}. Specified in any of the following ways, either in the Stata command window or as part of a new do-file, {bf:reprun} will execute the complete do-file {c 34}{it:myfile.do}{c 34} once (Run 1), and record the {c 34}seed RNG state{c 34}, {c 34}sort order RNG{c 34}, and {c 34}data checksum{c 34} after the execution of every line, as well as the exact data in certain cases. {bf:reprun} will then execute {c 34}{it:myfile.do}{c 34} a second time (Run 2), and find all {it:changes} and {it:mismatches} in these states throughout Run 2. A table of mismatches will be reported in the Results window, as well as in a SMCL file in a new directory called {inp:/reprun/} in the same location as {c 34}{it:myfile.do}{c 34}.  
{p_end}

{input}{space 8}reprun "myfile.do"
{text}
{pstd}or 
{p_end}

{input}{space 8}reprun "path/to/folder/myfile.do"
{text}
{pstd}or 
{p_end}

{input}{space 8}local myfolder "/path/to/folder"
{space 8}reprun "`myfolder'/myfile.do" 
{text}
{dlgtab:Example 2}

{pstd}This example is similar to example 1, but the {inp:/reprun/} directory containing the SMCL file will be stored in the location specified by the {bf:using} argument. 
{p_end}

{input}{space 8}reprun "myfile.do" using "path/to/report"
{text}
{pstd}or 
{p_end}

{input}{space 8}reprun "path/to/folder/myfile.do" using "path/to/report"
{text}
{pstd}or 
{p_end}

{input}{space 8}local myfolder "/path/to/folder"
{space 8}reprun "`myfolder'/myfile.do" using "`myfolder'/report" 
{text}
{dlgtab:Example 3}

{pstd}Assume {c 34}{it:myfile.do}{c 34} contains the following code:
{p_end}

{input}{space 8}sysuse census.dta, clear
{space 8}isid state, sort
{space 8}gen group = runiform() < .5
{space 8}bys group: gen n_obs = _n
{space 8}drop if n_obs > 22
{text}
{pstd}Running a reproducibility check on this do-file using {bf:reprun} will generate a table listing {it:mismatches} in Stata state between Run 1 and Run 2. 
{p_end}

{input}{space 8}reprun "myfile.do"
{text}
{pstd}In this specific code block, the following lines will be flagged for mismatches:
{p_end}

{pstd}Line 3: {inp:gen group = runiform() < .5} 
This line generates a new variable {inp:group} based on a random uniform distribution. The RNG state will differ between Run 1 and Run 2 unless the random seed is explicitly set before this command. As a result, a mismatch in the {c 34}seed RNG state{c 34} will be flagged. 
{p_end}

{pstd}Line 4: {inp:bys group: gen n_obs = _n} 
This line sorts the data by the newly generated {inp:group} variable and creates a new variable {inp:n_obs} based on this sorted order. Since group is generated using {inp:runiform()} without setting a seed, it will differ in each run, causing the sort order to vary. As a result, a mismatch in the {c 34}sort order RNG{c 34} will be flagged. If the sort order is not consistent between runs, the subsequent operations on the data can result in different outputs, causing further mismatches. 
{p_end}

{pstd}Lines 3-5: These lines will also be flagged for {c 34}data checksum{c 34} mismatches. The {inp:runiform()} function in line 3 introduces randomness, and the {inp:sort} in line 4 can lead to different data orders between runs. These changes propagate to line 5 {inp:drop if n_obs > 22}, where the number of observations dropped may differ between runs due to the changes in {inp:n_obs}. The data checksum comparison will detect these differences, leading to mismatches being flagged. 
{p_end}

{dlgtab:Example 4}

{pstd}Using the  {bf:{ul:v}erbose} option generates more detailed tables where any lines across Run 1 and Run 2 mismatch {it:**or**} change for any value. In addition to the output in Example 3, it will also flag line 2 for changes in {c 34}seed RNG state{c 34} and {c 34}data checksum{c 34}.
{p_end}

{input}{space 8}reprun "myfile.do", verbose
{text}
{dlgtab:Example 5}

{pstd}Using the {bf:{ul:c}ompact} option generates less detailed tables where only lines with mismatched seed or sort order RNG changes during Run 1 or Run 2, and mismatches between the runs, are flagged and reported. The output will be similar to Example 3; however, only lines 3 and 4 will be flagged for {c 34}data checksum{c 34}.
{p_end}

{input}{space 8}reprun "myfile.do", compact
{text}
{dlgtab:Example 6}
{pstd}Running reproducibility check on a set of do-files called by a main do-file. For example, the main do-file might contain the following code:
{p_end}

{input}{space 8}local myfolder "/path/to/folder"
{space 8}do "`myfolder'/myfile1.do" 
{space 8}do "`myfolder'/myfile2.do 
{text}
{pstd}Running the reproducibility check on {c 34}{it:main.do}{c 34} will return tables listing mismatches in {c 34}{it:myfile1.do}{c 34}, {c 34}{it:myfile2.do}{c 34}, and {c 34}{it:main.do}{c 34}. For instance, if there are mismatches between Run 1 and Run 2 in {c 34}{it:myfile1.do}{c 34}, every line with mismatches will be flagged in a table. Additionally, line 2 in {c 34}{it:main.do}{c 34} will be flagged for calling {c 34}{it:myfile1.do}{c 34}.
{p_end}

{input}{space 8}reprun "main.do"
{text}
{title:Feedback, bug reports and contributions}

{pstd}Read more about these commands on {browse "https://github.com/worldbank/repkit":this repo} where this package is developed. Please provide any feedback by {browse "https://github.com/worldbank/repkit/issues":opening an issue}. PRs with suggestions for improvements are also greatly appreciated.
{p_end}

{title:Authors}

{pstd}LSMS Team, The World Bank lsms@worldbank.org
DIME Analytics, The World Bank dimeanalytics@worldbank.org
{p_end}
