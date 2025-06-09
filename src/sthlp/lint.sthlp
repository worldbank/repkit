{smcl}
{* *! version 3.3 20250524}{...}
{hline}
{pstd}help file for {hi:lint}{p_end}
{hline}

{title:Title}

{phang}{bf:lint} – Detects and corrects bad coding practices in Stata do-files.
{p_end}

{title:Syntax}

{phang}{bf:lint} {c 34}{it:input_file}{c 34} [using {c 34}{it:output_file}{c 34}], [{it:options}]
{p_end}

{phang}The {inp:lint} command operates in two modes: 
{p_end}

{phang}1. {bf:Detection} mode identifies bad coding practices in Stata do-files and reports them.
{p_end}

{phang}2. {bf:Correction} mode applies corrections to a Stata do-file based on the issues detected.
{p_end}

{phang}In {bf:detection} mode, the command displays suggested corrections and potential issues in Stata{c 39}s Results window.  
{bf:Correction} mode is activated when an {it:output_file} is specified with {bf:using}; the command then writes a new file with the applied corrections to {it:output_file}.  
Note that not all issues flagged in {bf:detection} mode can be automatically corrected.
{p_end}

{phang}To use this command, you need Stata version 16 or higher, Python, and the {browse "https://pandas.pydata.org":Pandas} Python package installed.
For instructions on installing Python and integrating it with Stata, see {browse "https://blog.stata.com/2020/08/18/stata-python-integration-part-1-setting-up-stata-to-use-python/":this guide}.
For installing Python packages, refer to {browse "https://blog.stata.com/2020/09/01/stata-python-integration-part-3-how-to-install-python-packages":this guide}.
{p_end}

{synoptset 16}{...}
{p2coldent:{it:options}}Description{p_end}
{synoptline}
{synopt: {bf:{ul:v}erbose}}Shows a report of all bad practices and issues flagged by the command.{p_end}
{synopt: {bf:{ul:nosum}mary}}Suppresses the summary table with counts of bad practices and potential issues.{p_end}
{synopt: {bf:{ul:e}xcel}({it:filename})}Saves the verbose output in an Excel file.{p_end}
{synopt: {bf:{ul:i}ndent}({it:integer})}Number of whitespaces used when checking indentation (default: 4).{p_end}
{synopt: {bf:{ul:l}inemax}({it:integer})}Maximum number of characters in a line (default: 80).{p_end}
{synoptline}

{dlgtab:Options specific to the correction mode}

{synoptset 14}{...}
{p2coldent:{it:options}}Description{p_end}
{synoptline}
{synopt: {bf:{ul:auto}matic}}Suppresses the prompt asking users which correction to apply.{p_end}
{synopt: {bf:{ul:s}pace}({it:integer})}Number of whitespaces used instead of hard tabs when replacing hard tabs with spaces for indentation (default: same value used for the option {bf:indent()}, 4 when no value is defined).{p_end}
{synopt: {bf:replace}}Allows the command to overwrite any existing {it:output} file.{p_end}
{synopt: {bf:force}}Allows the {it:input_file} to be the same as {it:output_file}. Not recommended, see below.{p_end}
{synoptline}

{title:Description}

{pstd}This command is a linting tool for Stata code that helps standardize code formatting and identify bad practices.  
For further discussion of linting tools, see {inp:https://en.wikipedia.org/wiki/Lint_(software)}. 
{p_end}

{pstd}The linting rules used in this command are based on the DIME Analytics {browse "https://worldbank.github.io/dime-data-handbook/coding.html#the-dime-analytics-stata-style-guide":Stata Style Guide}.  
All style guides are inherently subjective, and differences in preferences exist.  
An exact list of the rules used by this command can be found in {browse "https://github.com/worldbank/repkit/blob/add-linter/src/vignettes/linting-rules.md":this article} on the {inp:repkit} web documentation.   
See the list of rules and the DIME Analytics Stata Style Guide for a discussion on the motivations for these rules.
{p_end}

{title:Options}

{pstd}{bf:{ul:v}erbose} displays a detailed report of all bad practices and issues flagged by the command in the Results window. By default, only a summary table with counts for each linting rule is shown.
{p_end}

{pstd}{bf:{ul:nosum}mary} suppresses the summary table of flagged occurrences.
{p_end}

{pstd}{bf:{ul:e}xcel}({it:filename}) exports the verbose output to an Excel file at the specified location.
{p_end}

{pstd}{bf:{ul:i}ndent}({it:integer}) sets the number of whitespaces used when checking indentation. Default: 4.
{p_end}

{pstd}{bf:{ul:l}inemax}({it:integer}) sets the maximum number of characters allowed in a single line. Default: 80.
{p_end}

{dlgtab:Options specific to the correction feature}

{pstd}{bf:{ul:auto}matic} suppresses the interactive prompt before applying corrections. By default, the command asks for confirmation before applying identified corrections.
{p_end}

{pstd}{bf:{ul:s}pace}({it:integer}) sets the number of whitespaces to replace instead of hard tabs for indentation. Default: same value used for the option {bf:indent()}, 4 when no value is defined.
{p_end}

{pstd}{bf:replace} allows overwriting an existing {it:output} file.
{p_end}

{pstd}{bf:force} allows the output file name to be the same as the input file, overwriting the original do-file. {bf:This is not recommended}; see details in the section below.
{p_end}

{dlgtab:Recommended workflow for correction mode}

{pstd}The {it:correction} mode applies fewer rules than identified in {it:detection} mode.
You may find that {inp:lint {c 34}input_file{c 34}} flags more issues than can be automatically corrected with {inp:lint {c 34}input_file{c 34} using {c 34}output_file{c 34}}. 
{p_end}

{pstd}A recommended workflow is to first use detection to identify bad practices, then manually correct them if there are only a few. This minimizes the risk of unintended changes.If many issues are detected, use the correction mode to address as many as possible, then review and manually fix any remaining issues.
{p_end}

{pstd}Avoid using the {inp:force} option to overwrite the original input file. 
Instead, keep the original file as a backup to safeguard against unintended changes. Always verify that the corrected do-file produces the expected results before replacing the original file.
{p_end}

{title:Examples}

{pstd}The following examples illustrate basic usages of lint.
The example file {inp:bad.do} referred to below can be downloaded {browse "https://github.com/worldbank/repkit/blob/lint-helpfile-update/src/tests/lint/test-files/bad.do":here}. 
{p_end}

{pstd}Additional examples with more verbose explanation be found {browse "https://github.com/worldbank/repkit/blob/add-linter/src/vignettes/lint-examples.md":here}
{p_end}

{dlgtab:Detecting bad coding practices}

{pstd}1. The basic usage is to point to a do-file that requires revision as follows:
{p_end}

{input}{space 8}lint "test/bad.do"
{text}
{pstd}2. Show bad coding practices line-by-line
{p_end}

{input}{space 8}lint "test/bad.do", verbose
{text}
{pstd}3. Remove the summary of bad practices
{p_end}

{input}{space 8}lint "test/bad.do", nosummary
{text}
{pstd}4. Specify the number of whitespaces used for detecting indentation practices (default: 4):
{p_end}

{input}{space 8}lint "test/bad.do", indent(2)
{text}
{pstd}5. Specify the maximum number of characters in a line allowed when detecting line extension (default: 80):
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

{pstd}The basic usage of the correction feature requires to specify the input do-file and the output do-file that will have the corrections. If you do not include any options, the linter will ask you confirm if you want a specific bad practice to be corrected for each bad practice detected:
{p_end}

{pstd}1. Basic correction use (the linter will ask what to correct):
{p_end}

{input}{space 8}lint "test/bad.do" using "test/bad_corrected.do"
{text}
{pstd}2. Correction while defining the number of spaces to replace hard tabs with:
{p_end}

{input}{space 8}lint "test/bad.do" using "test/bad_corrected.do", space(2)
{text}
{pstd}3. Automatic use (Stata will correct the file automatically):
{p_end}

{input}{space 8}lint "test/bad.do" using "test/bad_corrected.do", automatic
{text}
{pstd}4. Use the same name for the output file (note that this will overwrite the input file, this is not recommended):
{p_end}

{input}{space 8}lint "test/bad.do" using "test/bad.do", automatic force
{text}
{pstd}5. Replace the output file if it already exists
{p_end}

{input}{space 8}lint "test/bad.do" using "test/bad_corrected.do", automatic replace
{text}
{title:Feedback, bug reports and contributions}

{pstd}Read more about these commands on {browse "https://github.com/worldbank/repkit":this repo} where this package is developed. Please provide any feedback by {browse "https://github.com/worldbank/repkit/issues":opening an issue}. PRs with suggestions for improvements are also greatly appreciated.
{p_end}

{title:Authors}

{pstd}DIME Analytics, The World Bank dimeanalytics@worldbank.org
{p_end}
