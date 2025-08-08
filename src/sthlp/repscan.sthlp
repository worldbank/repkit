{smcl}
{* *! version 4.0 20250729}{...}
{hline}
{pstd}help file for {hi:repscan}{p_end}
{hline}

{title:Title}

{phang}{bf:repscan} - Detect the use of commands linked to common reproducibility failures in Stata do-files.
{p_end}

{title:Syntax}

{phang}{bf:repscan} {c 34}{it:do-file.do}{c 34} [, {bf:complete}]
{p_end}

{phang}{bf:repscan} scans a do-file, detecting commands known to possibly compromise reproducibility in Stata code execution.
By default, it flags only commands which have a {it:high probability} of causing reproducibility failures.
Using the option {it:complete} tells {bf:repscan} to also flag commands which have a {it:lower probability} of causing reproducibility issues.
{p_end}

{synoptset 8}{...}
{p2coldent:{it:options}}Description{p_end}
{synoptline}
{synopt: {bf:complete}}Runs {bf:repscan} in {it:complete} detection mode, detecting all commands known to cause reproducibility issues in Stata.{p_end}
{synoptline}

{title:Description}

{pstd}{bf:repscan} reads a do-file and flags commands known to potentially compromise reproducibility.
By alerting users of potential problems—such as commands affected by uncontrolled randomness, system-dependent sortings, or unstable default behaviors—{bf:repscan} allows researchers to refine their code and ensure their results can be reproduced.
The default use of {bf:repscan} only flags commands with a high probability of causing reproducibility failures, while using the option {it:complete} flags commands with a lower probability of causing reproducibility issues as well.
{p_end}

{dlgtab:Commands with a high probability of causing reproducibility issues}

{pstd}1. {bf:Using {inp:runiform()} without setting a random seed}: {inp:runiform()} generates random numbers based on the current state of Stata{c 39}s random number generator, which is set with a random seed. 
If you do not set the seed explicitly (using {inp:set seed}), in your code before using {inp:runiform()}, Stata will produce a different sequence of random numbers each time, breaking reproducibility. 
{p_end}

{pstd}2. {bf:Many-to-many merges}: A many-to-many merge ({inp:merge m:m}) is problematic for reproducibility because the operation matches observations based on the order in which they appear within groups defined by the merge variables. 
Since neither dataset is uniquely identified by the merge keys, Stata pairs the first observation in the master dataset with the first in the using dataset, the second with the second, and so on.
If the number of observations differs between datasets for a given group, the last observation of the shorter group is repeatedly matched with the remaining observations of the longer group.
The input datasets of {inp:merge m:m} need to be uniquely and consistently sorted for the result to be reproducible. 
{p_end}

{pstd}3. {bf:Forced dropping of duplicated observations}: Using {inp:duplicates drop varlist, force} may cause reproducibility problems because it keeps only the first occurrence of each duplicate, determined by the current order of the data. 
If the dataset is not sorted in a unique and consistent way before running this command, the specific observations that are kept or dropped can vary depending on how the data happened to be ordered at that moment.
{p_end}

{dlgtab:Commands with a lower probability of causing reproducibility issues}

{pstd}1. {bf:Sorting or using bysort}: When using the {inp:sort} command on a variable that contains ties (i.e., multiple observations with the same value), Stata must decide how to order those tied observations. 
If there is no additional variable to break the tie, the order among tied observations is not guaranteed to be the same every time you run the code.
The most robust way to ensure reproducibility when sorting is to sort on a variable or set of variables that uniquely identify each observation.
{p_end}

{pstd}2. {bf:set sortseed}: the {inp:set sortseed} (or {inp:set sortrngstate}) command is sometimes used in an attempt to make the ordering of tied values in sorts reproducible. 
However, this approach does not fully solve the problem and can still lead to different results across Stata editions or hardware.
As Stata’s own documentation warns, the command is highly esoteric and not recommended for general use.
The core issue is that Stata prioritizes speed in its sorting algorithms and does not guarantee reproducibility of tie-breaking across different environments.
Specifically, Stata/SE and Stata/MP use the random tie-breaking differently, so even with the same seed or state, the order of tied observations can differ between Stata editions, and even between runs on different numbers of processors.
{p_end}

{pstd}3. {bf:reclink}: some of the record linkage operations performed by {inp:reclink} may involve tie-breaking when multiple matches are equally likely. 
If the code does not control for this (e.g., by sorting data in a stable, unique way before matching), the results may differ across runs or environments.
{p_end}

{pstd}4. {bf:Setting a random seed without specifying a Stata version first}: setting the random seed without first specifying the version can break reproducibility because the random-number generation algorithms may change between versions.
By setting the version first (using the {inp:version} command), you ensure that Stata uses the same algorithms as in that specified version, making your results consistent and reproducible across different environments and over time. 
{p_end}

{dlgtab:Skipping lines}

{pstd}{bf:repscan} will skip lines ending with the in-line comment: {it:RESPCAN OK}.
This can be used to avoid flagging issues the user knows will not break reproducibility.
For example, a line with:
{p_end}

{input}{space 8}* Unique sorting
{space 8}sort id // REPSCAN OK
{text}
{pstd}Will be skipped by {bf:repscan} when using the command with the option {it:complete}.
{p_end}

{title:Examples}

{pstd}Basic functionality:
{p_end}

{input}{space 8}repscan "path/to/do-file.do"
{text}
{pstd}Complete functionality:
{p_end}

{input}{space 8}repscan "path/to/do-file.do", complete
{text}
{title:Feedback, bug reports and contributions}

{pstd}{inp:repscan} is part of the Stata package {inp:repkit}, containing tools for reproducible Stata coding. 
Read more about these commands on {browse "https://github.com/worldbank/repkit":this repository} where this package is developed.
Provide any feedback by {browse "https://github.com/worldbank/repkit/issues":opening an issue}.
Pull requests with suggestions for improvements or bug fixes are also greatly appreciated.
{p_end}

{title:Authors}

{pstd}DIME Analytics, The World Bank dimeanalytics@worldbank.org
{p_end}

{title:Acknowledgements}

{pstd}Christian Walker tested the command extensively on actual code and reported bugs to the authors.
{p_end}
