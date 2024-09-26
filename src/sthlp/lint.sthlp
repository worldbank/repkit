{smcl}
{* *! version 3.0 20240923}{...}
{hline}
{pstd}help file for {hi:lint}{p_end}
{hline}

{title:Title}

{phang}{bf:lint} - detects and corrects bad coding practices in Stata do-files
following the
{browse "https://worldbank.github.io/dime-data-handbook/coding.html#the-dime-
analytics-stata-style-guide":DIME Analytics Stata Style Guide}.
{p_end}

{phang}For this command to run, you will need Stata version 16 or greater,
Python, and the Python package {browse "https://pandas.pydata.org":Pandas}
installed.
{p_end}

{phang}To install Python and integrate it with Stata, refer to
{browse "https://blog.stata.com/2020/08/18/stata-python-integration-part-1-setting-up-stata-to-use-python/":this page}.
{p_end}

{phang}To install Python packages, refer to
{browse "https://blog.stata.com/2020/09/01/stata-python-integration-part-3-how-to-install-python-packages/":this page}.
{p_end}

{title:Syntax}

{phang}{bf:lint} {c 34}{it:input_file}{c 34} [using {c 34}{it:output_file}{c 34}] , [{it:options}]
{p_end}

{phang}The lint command can be broken into two functionalities:
{p_end}

{phang}1. {bf:Detection} identifies bad coding practices in a Stata do-files
{p_end}

{phang}2. {bf:Correction} corrects bad coding practices in a Stata do-file.
{p_end}

{phang}If an {it:output_file} is specified with {bf:using}, then the linter will
apply the {bf:Correction} functionality and will write a new file with
corrections. If not, the command will only apply the {bf:Detection}
functionality, returning a report of suggested corrections and potential issues
of the do-file in Stata{c 39}s Results window. Users should note that not all
the bad practices identified in {bf:Detection} can be amended by {bf:Correction}.
{p_end}

{synoptset 16}{...}
{p2coldent:{it:options}}Description{p_end}
{synoptline}
{synopt: {bf:{ul:v}erbose}}Report bad practices and issues found on each line of
the do-file.{p_end}
{synopt: {bf:{ul:nosum}mary}}Suppress summary table of bad practices and
potential issues.{p_end}
{synopt: {bf:{ul:i}ndent}({it:integer})}Number of whitespaces used when checking
indentation coding practices (default: 4).{p_end}
{synopt: {bf:{ul:s}pace}({it:integer})}Number of whitespaces used instead of
hard tabs when checking indentation practices (default: same as indent).{p_end}
{synopt: {bf:{ul:l}inemax}({it:integer})}Maximum number of characters in a line
when checking line extension practices (default: 80).{p_end}
{synopt: {bf:{ul:e}xcel}({it:filename})}Save an Excel file of line-by-line
results.{p_end}
{synopt: {bf:force}}Allow the output file name to be the same as the name of the
input file; overwriting the original do-file. {bf:The use of this option is not
recommended} because it is slightly possible that the corrected do-file created
by the command will break something in your code and you should always keep a
backup of it.{p_end}
{synopt: {bf:{ul:auto}matic}}Correct all bad coding practices without asking if
you want each bad coding practice to be corrected or not.  By default, the
command will ask the user about each correction interactively after producing
the summary report.{p_end}
{synopt: {bf:replace}}Overwrite any existing {it:output} file.{p_end}
{synoptline}

{title:Description}

{dlgtab:Detect functionality}

{pstd}{bf:Bad style practices and potential issues detected:}
{p_end}

{pstd}{bf:Use whitespaces instead of hard tabs}
{p_end}

{pstd}- Use whitespaces (usually 2 or 4) instead of hard tabs.
{p_end}

{pstd}{bf:Avoid abstract index names}
{p_end}

{pstd}- In for-loop statements, index names should describe what the code is
looping over. For example, avoid writing code like this:
{p_end}

{input}{space 8}  foreach i of varlist cassava maize wheat { }
{text}
{pstd}- Instead, looping commands should name the index local descriptively:
{p_end}

{input}{space 8}  foreach crop of varlist cassava maize wheat { }
{text}
{pstd}{bf:Use proper indentations}
{p_end}

{pstd}- After declaring for-loop statements or if-else statements, add
indentation with whitespaces (usually 2 or 4) in the lines inside the loop.
{p_end}

{pstd}{bf:Use indentations after declaring newline symbols (///)}
{p_end}

{pstd}- After a new line statement (///), add indentation (usually 2 or 4
whitespaces).
{p_end}

{pstd}{bf:Use the {c 34}!missing(){c 34} function for conditions with missing values}
{p_end}

{pstd}- For clarity, use {inp:!missing(var)} instead of {inp:var < .} or
{inp:var != .}
{p_end}

{pstd}{bf:Add whitespaces around math symbols (+, =, <, >)}
{p_end}

{pstd}- For better readability, add whitespaces around math symbols. For
example, do {inp:gen a = b + c if d == e} instead of {inp:gen a=b+c if d==e}.
{p_end}

{pstd}{bf:Specify the condition in an {c 34}if{c 34} statement}
{p_end}

{pstd}- Always explicitly specify the condition in the if statement. For
example, declare {inp:if var == 1} instead of just using {inp:if var}.
{p_end}

{pstd}{bf:Do not use {c 34}#delimit{c 34}, instead use{c 34}///{c 34} for line breaks}
{p_end}

{pstd}- More information about the use of line breaks
{browse "https://worldbank.github.io/dime-data-handbook/coding.html#line-breaks":here}.
{p_end}

{pstd}{bf:Do not use cd to change current folder}
{p_end}

{pstd}- Use absolute and dynamic file paths. More about this
{browse "https://worldbank.github.io/dime-data-handbook/coding.html#writing-file-paths":here}.
{p_end}

{pstd}{bf:Use line breaks in long lines}
{p_end}

{pstd}- For lines that are too long, use {inp:///} to divide them into multiple
lines.  It is recommended to restrict the number of characters in a line to 80
or less.
{p_end}

{pstd}{bf:Use curly brackets for global macros}
{p_end}

{pstd}- Always use {inp:} for global macros.  For example, use {inp:} instead
of {inp:}.
{p_end}

{pstd}{bf:Include missing values in condition expressions}
{p_end}

{pstd}- Condition expressions like {inp:var != 0} or {inp:var > 0} are evaluated
to true for missing values. Make sure to explicitly take missing values into
account by using {inp:missing(var)} in expressions.
{p_end}

{pstd}{bf:Check if backslashes are not used in file paths}
{p_end}

{pstd}- Check if backslashes {inp:(%} are not used in file paths. If you are
using them, then replace them with forward slashes {inp:(/)}. Users should note
that the linter might not distinguish perfectly which uses of a backslash are
file paths. In general, this flag will come up every time a backslash is used in
the same line as a local, glocal, or the cd command.
{p_end}

{pstd}{bf:Check if tildes (~) are not used for negations}
{p_end}

{pstd}- If you are using tildes {inp:(~)} are used for negations, replace them
with bangs {inp:(!)}.
{p_end}

{dlgtab:Correct functionality}

{pstd}{bf:Coding practices to be corrected:}
{p_end}

{pstd}Users should note that the Correct feature does not correct all the bad
practices detected.  It only corrects the following:
{p_end}

{pstd}- Replaces the use of {inp:#delimit} with three forward slashes
{inp:(///)} in each line affected by {inp:#delimit}
{p_end}

{pstd}- Replaces hard tabs with soft spaces (4 by default). The amount of spaces
can be set with the {inp:tab_space()} option
{p_end}

{pstd}- Indents lines inside curly brackets with 4 spaces by default. The amount
of spaces can be set with the {inp:indent()} option
{p_end}

{pstd}- Breaks long lines into multiple lines. Long lines are considered to have
more than 80 characters by default, but this setting can be changed with the
option {inp:linemax()}.  Note that lines can only be split in whitespaces that
are not inside parentheses, curly brackets, or double quotes. If a line does not
have any whitespaces, the linter will not be able to break a long line.
{p_end}

{pstd}- Adds a whitespace before opening curly brackets, except for globals
{p_end}

{pstd}- Removes redundant blank lines after closing curly brackets
{p_end}

{pstd}- Removes duplicated blank lines
{p_end}

{pstd}If the option {inp:automatic} is omitted, Stata will prompt the user to
confirm that they want to correct each of these bad practices only in case they
are detected.  If none of these are detected, it will show a message saying that
none of the bad practices it can correct were detected.
{p_end}

{title:Examples}

{pstd}The following examples illustrate the basic usage of lint. Additional
examples can be found
{browse "https://github.com/worldbank/repkit/blob/add-linter/src/vignettes/lint-examples.md":here}
{p_end}

{dlgtab:Detecting bad coding practices}

{pstd}The basic usage is to point to a do-file that requires revision as
follows:
{p_end}

{input}{space 8}lint "test/bad.do"
{text}
{pstd}For the detection feature you can use all the options but {it:automatic},
{it:force}, and {it:replace}, which are part of the correction functionality.
{p_end}

{pstd}{bf:{ul:Options:}}
{p_end}

{pstd}1. Show bad coding practices line-by-line
{p_end}

{input}{space 8}lint "test/bad.do", verbose
{text}
{pstd} 2. Remove the summary of bad practices
{p_end}

{input}{space 8}lint "test/bad.do", nosummary
{text}
{pstd}3. Specify the number of whitespaces used for detecting indentation
practices (default: 4):
{p_end}

{input}{space 8}lint "test/bad.do", indent(2)
{text}
{pstd}4. Specify the number of whitespaces used instead of hard tabs for
detecting indentation practices (default: same value used in indent):
{p_end}

{input}{space 8}lint "test/bad.do", tab_space(6)
{text}
{pstd}5. Specify the maximum number of characters in a line allowed when
detecting line extension (default: 80):
{p_end}

{input}{space 8}lint "test/bad.do", linemax(100)
{text}
{pstd}6. Export to Excel the results of the line by line analysis
{p_end}

{input}{space 8}lint "test/bad.do", excel("test_dir/detect_output.xlsx")
{text}
{pstd}7. You can also use this command to test all the do-files in a folder:
{p_end}

{input}{space 8}lint "test/"
{text}
{dlgtab:Correcting bad coding practices}

{pstd}The basic usage of the correction feature requires to specify the input
do-file and the output do-file that will have the corrections. If you do not
include any options, the linter will ask you confirm if you want a specific bad
practice to be corrected for each bad practice detected:
{p_end}

{pstd}1. Basic correction use (the linter will ask what to correct):
{p_end}

{input}{space 8}lint "test/bad.do" using "test/bad_corrected.do"
{text}
{pstd}2. Automatic use (Stata will correct the file automatically):
{p_end}

{input}{space 8}lint "test/bad.do" using "test/bad_corrected.do", automatic
{text}
{pstd}3. Use the same name for the output file (note that this will overwrite
the input file, this is not recommended):
{p_end}

{input}{space 8}lint "test/bad.do" using "test/bad.do", automatic force
{text}
{pstd}4. Replace the output file if it already exists
{p_end}

{input}{space 8}lint "test/bad.do" using "test/bad_corrected.do", automatic
replace
{text}
{title:Feedback, bug reports and contributions}

{pstd}Read more about these commands on
{browse "https://github.com/worldbank/repkit":this repo} where this package is
developed. Please provide any feedback by
{browse "https://github.com/worldbank/repkit/issues":opening an issue}.
PRs with suggestions for improvements are also greatly appreciated.
{p_end}

{title:Authors}

{pstd}DIME Analytics, The World Bank dimeanalytics@worldbank.org
{p_end}
