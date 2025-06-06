# Title

__lint__ – Detects and corrects bad coding practices in Stata do-files.

# Syntax

__lint__ "_input_file_" [using "_output_file_"], [_options_]

The `lint` command operates in two modes:

1. __Detection__ mode identifies bad coding practices in Stata do-files and reports them.

2. __Correction__ mode applies corrections to a Stata do-file based on the issues detected.

In __detection__ mode, the command displays suggested corrections and potential issues in Stata's Results window.  
__Correction__ mode is activated when an _output_file_ is specified with __using__; the command then writes a new file with the applied corrections to _output_file_.  
Note that not all issues flagged in __detection__ mode can be automatically corrected.

To use this command, you need Stata version 16 or higher, Python, and the [Pandas](https://pandas.pydata.org) Python package installed.
For instructions on installing Python and integrating it with Stata, see [this guide](https://blog.stata.com/2020/08/18/stata-python-integration-part-1-setting-up-stata-to-use-python/).
For installing Python packages, refer to [this guide](https://blog.stata.com/2020/09/01/stata-python-integration-part-3-how-to-install-python-packages).

| _options_ | Description |
|-----------|-------------|
| __**v**erbose__ | Shows a report of all bad practices and issues flagged by the command. |
| __**nosum**mary__ | Suppresses the summary table with counts of bad practices and potential issues. |
| __**e**xcel__(_filename_) | Saves the verbose output in an Excel file. |
| __**i**ndent__(_integer_) | Number of whitespaces used when checking indentation (default: 4). |
| __**l**inemax__(_integer_) | Maximum number of characters in a line (default: 80). |

## Options specific to the correction mode

| _options_ | Description |
|-----------|-------------|
| __**auto**matic__ | Suppresses the prompt asking users which correction to apply. |
| __**s**pace__(_integer_) | Number of whitespaces used instead of hard tabs when replacing hard tabs with spaces for indentation (default: same value used for the option __indent()__, 4 when no value is defined). |
| __replace__ | Allows the command to overwrite any existing _output_ file. |
| __force__ | Allows the _input_file_ to be the same as _output_file_. Not recommended, see below. |

# Description

This command is a linting tool for Stata code that helps standardize code formatting and identify bad practices.  
For further discussion of linting tools, see `https://en.wikipedia.org/wiki/Lint_(software)`.

The linting rules used in this command are based on the DIME Analytics [Stata Style Guide](https://worldbank.github.io/dime-data-handbook/coding.html#the-dime-analytics-stata-style-guide).  
All style guides are inherently subjective, and differences in preferences exist.  
An exact list of the rules used by this command can be found in [this article](https://github.com/worldbank/repkit/blob/add-linter/src/vignettes/linting-rules.md) on the `repkit` web documentation.  
See the list of rules and the DIME Analytics Stata Style Guide for a discussion on the motivations for these rules.

# Options

__**v**erbose__ displays a detailed report of all bad practices and issues flagged by the command in the Results window. By default, only a summary table with counts for each linting rule is shown.

__**nosum**mary__ suppresses the summary table of flagged occurrences.

__**e**xcel__(_filename_) exports the verbose output to an Excel file at the specified location.

__**i**ndent__(_integer_) sets the number of whitespaces used when checking indentation. Default: 4.

__**l**inemax__(_integer_) sets the maximum number of characters allowed in a single line. Default: 80.

## Options specific to the correction feature

__**auto**matic__ suppresses the interactive prompt before applying corrections. By default, the command asks for confirmation before applying identified corrections.

__**s**pace__(_integer_) sets the number of whitespaces to replace instead of hard tabs for indentation. Default: same value used for the option __indent()__, 4 when no value is defined.

__replace__ allows overwriting an existing _output_ file.

__force__ allows the output file name to be the same as the input file, overwriting the original do-file. __This is not recommended__; see details in the section below.

## Recommended workflow for correction mode

The _correction_ mode applies fewer rules than identified in _detection_ mode.
You may find that `lint "input_file"` flags more issues than can be automatically corrected with `lint "input_file" using "output_file"`.

A recommended workflow is to first use detection to identify bad practices, then manually correct them if there are only a few. This minimizes the risk of unintended changes.If many issues are detected, use the correction mode to address as many as possible, then review and manually fix any remaining issues.

Avoid using the `force` option to overwrite the original input file.
Instead, keep the original file as a backup to safeguard against unintended changes. Always verify that the corrected do-file produces the expected results before replacing the original file.

# Examples

The following examples illustrate basic usages of lint.
The example file `bad.do` referred to below can be downloaded [here](https://github.com/worldbank/repkit/blob/lint-helpfile-update/src/tests/lint/test-files/bad.do).

Additional examples with more verbose explanation be found [here](https://github.com/worldbank/repkit/blob/add-linter/src/vignettes/lint-examples.md)

## Detecting bad coding practices

1. The basic usage is to point to a do-file that requires revision as follows:

```
lint "test/bad.do"
```

2. Show bad coding practices line-by-line

```
lint "test/bad.do", verbose
```

3. Remove the summary of bad practices

```
lint "test/bad.do", nosummary
```

4. Specify the number of whitespaces used for detecting indentation practices (default: 4):

```
lint "test/bad.do", indent(2)
```

5. Specify the maximum number of characters in a line allowed when detecting line extension (default: 80):

```
lint "test/bad.do", linemax(100)
```

6. Export to Excel the results of the line by line analysis

```
lint "test/bad.do", excel("test_dir/detect_output.xlsx")
```

7. You can also use this command to test all the do-files in a folder:

```
lint "test/"
```

## Correcting bad coding practices

The basic usage of the correction feature requires to specify the input do-file and the output do-file that will have the corrections. If you do not include any options, the linter will ask you confirm if you want a specific bad practice to be corrected for each bad practice detected:

1. Basic correction use (the linter will ask what to correct):

```
lint "test/bad.do" using "test/bad_corrected.do"
```

2. Correction while defining the number of spaces to replace hard tabs with:

```
lint "test/bad.do" using "test/bad_corrected.do", space(2)
```

3. Automatic use (Stata will correct the file automatically):

```
lint "test/bad.do" using "test/bad_corrected.do", automatic
```

4. Use the same name for the output file (note that this will overwrite the input file, this is not recommended):

```
lint "test/bad.do" using "test/bad.do", automatic force
```

5. Replace the output file if it already exists

```
lint "test/bad.do" using "test/bad_corrected.do", automatic replace
```

# Feedback, bug reports and contributions

Read more about these commands on [this repo](https://github.com/worldbank/repkit) where this package is developed. Please provide any feedback by [opening an issue](https://github.com/worldbank/repkit/issues). PRs with suggestions for improvements are also greatly appreciated.

# Authors

DIME Analytics, The World Bank dimeanalytics@worldbank.org
